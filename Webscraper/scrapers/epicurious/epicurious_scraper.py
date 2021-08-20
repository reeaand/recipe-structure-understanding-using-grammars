import traceback
from threading import Thread

from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.common.exceptions import ElementClickInterceptedException, StaleElementReferenceException, \
    TimeoutException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from db.recipe_db_helper import RecipeDBHelper
from utils.proxy import proxyDict
from scrapers.epicurious.epicurious_recipe_extractor import EpicuriousRecipeExtractor

import requests

from utils.selenium_speedup import speedup_selenium


def extract_recipe_details(link):
    page = requests.get(link, proxies=proxyDict)
    extractor = EpicuriousRecipeExtractor(page.content)
    return extractor.extract_all()


class EpicuriousScraper:
    base_link = "https://www.epicurious.com"
    source = "Epicurious"

    def __init__(self):
        self.option = speedup_selenium()

    def find_recipe_links_on_page(self, page):
        soup = BeautifulSoup(page, 'lxml')
        recipe_box_elements = soup.find_all('a', class_='view-complete-item')

        links = [self.base_link + box['href'] for box in recipe_box_elements]
        links = links[1::2]

        return links

    def iterate_recipe_pages(self, start_page, end_page):
        links = []
        for index in range(start_page, end_page):
            page = requests.get(self.base_link +
                                "/search?content=recipe&page=" +
                                str(index) +
                                "&sort=mostReviewed",
                                proxies=proxyDict)
            page_links = self.find_recipe_links_on_page(page.content)
            links = links + page_links

        return links

    def expand_reviews(self, link, iterations):
        driver = webdriver.Chrome(chrome_options=self.option)
        driver.get(link)
        wait = WebDriverWait(driver, 3)

        popup_element = driver.find_elements_by_id("onetrust-accept-btn-handler")
        if len(popup_element) > 0:
            popup_element[0].click()

        while iterations > 0 or iterations == -1:
            if iterations != -1:
                iterations -= 1
            try:
                view_more_reviews_button = wait.until(EC.visibility_of_element_located(
                    (By.XPATH, '//button[text()="View More Reviews"]')))
                view_more_reviews_button.click()

            except ElementClickInterceptedException:
                driver.find_element_by_class_name("toggle-riser").click()
                if iterations != -1:
                    iterations += 1
            except (TimeoutException, StaleElementReferenceException):
                break

        expanded_page = driver.page_source
        driver.close()
        return expanded_page

    def extract_with_reviews(self, link):
        page = self.expand_reviews(link, 1)
        extractor = EpicuriousRecipeExtractor(page)
        return extractor.extract_reviews()

    def run_thread(self, links, w_reviews):
        db_helper = RecipeDBHelper()
        try:
            for link in links:
                recipe = extract_recipe_details(link)
                recipe.website = "Epicurious"
                recipe.link = link
                if w_reviews:
                    recipe.reviews.ratings, recipe.reviews.texts = self.extract_with_reviews(link)
                print("start " + recipe.title)
                db_helper.insert_all(recipe, w_reviews)
                print("end " + recipe.title)
            db_helper.close()
        except Exception:
            traceback.print_exc()

    def run(self, start, end, w_reviews):
        links = self.iterate_recipe_pages(start, end)
        print(len(links))

        threads = []
        for i in range(4):
            thread = Thread(target=self.run_thread,
                            args=(links[i::4], w_reviews))
            thread.start()
            threads.append(thread)

        for thread in threads:
            thread.join()
