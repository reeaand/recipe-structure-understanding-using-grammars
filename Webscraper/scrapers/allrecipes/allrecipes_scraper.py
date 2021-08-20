# import re
import traceback
from threading import Thread

from bs4 import BeautifulSoup

# from selenium import webdriver
# from selenium.common.exceptions import ElementClickInterceptedException, StaleElementReferenceException, \
#     TimeoutException
# from selenium.webdriver.common.by import By
# from selenium.webdriver.support.wait import WebDriverWait
# from selenium.webdriver.support import expected_conditions as EC
from db.recipe_db_helper import RecipeDBHelper
from scrapers.allrecipes.allrecipes_recipe_extractor import AllrecipesRecipeExtractor
from utils.proxy import proxyDict
from scrapers.yummly.yummly_recipe_extractor import YummlyRecipeExtractor

import requests

from utils.selenium_speedup import speedup_selenium


def extract_recipe_details(link):
    page = requests.get(link, proxies=proxyDict)
    extractor = AllrecipesRecipeExtractor(page.content, link)
    return extractor.extract_all()


class AllrecipesScraper:
    base_link = "https://www.allrecipes.com"
    source = "Allrecipes"

    def __init__(self):
        self.option = speedup_selenium()

    def find_recipe_links_plus_page(self, page):
        soup = BeautifulSoup(page, 'lxml')
        new_links = soup.find_all('a', class_='tout__imageLink')[1:]

        final_links = [self.base_link + link['href'] for link in new_links if 'gallery' not in link['href']]
        rating_wrappers = soup.find_all('div', class_='card__ratingContainer')

        ratings = []
        for wrapper in rating_wrappers:
            stars = wrapper.find_all('span', class_='rating-star active')
            rating = len(stars)
            ratings.append(rating)

        return ratings, final_links

    def run_thread(self, links, ratings, w_reviews):
        db_helper = RecipeDBHelper()
        try:
            for link, rating in zip(links, ratings):
                recipe = extract_recipe_details(link)
                if recipe.title == '':
                    continue
                recipe.website = "Allrecipes"
                recipe.link = link
                recipe.rating = rating
                if w_reviews:
                    recipe.reviews.ratings, recipe.reviews.texts = self.extract_with_reviews(link)
                print("start " + recipe.title)
                db_helper.insert_all(recipe, w_reviews)
                print("end " + recipe.title)
            db_helper.close()
        except Exception:
            traceback.print_exc()

    def run(self, start, end):
        for i in range(start, end):
            main_link = self.base_link + '/recipes/?page=' + str(i)
            page = requests.get(main_link, proxies=proxyDict)
            ratings, links = self.find_recipe_links_plus_page(page.content)

            threads = []
            for j in range(4):
                thread = Thread(target=self.run_thread,
                                args=(links[j::4], ratings[j::4], False))
                thread.start()
                threads.append(thread)

            for thread in threads:
                thread.join()
