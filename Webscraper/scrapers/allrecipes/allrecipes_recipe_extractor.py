import itertools

from selenium import webdriver
from selenium.webdriver.support.wait import WebDriverWait

from entities.recipe import Recipe
from scrapers.abstract_recipe_extractor import AbstractRecipeExtractor
from bs4 import BeautifulSoup

from utils.parsers.fraction_parser import convert_unicode_to_string
from utils.parsers.servings_parser import parse_servings
from utils.parsers.time_parser import parse_time


class AllrecipesRecipeExtractor(AbstractRecipeExtractor):

    def __init__(self, page, link):
        self.link = link
        self.recipe_dict = {}
        soup = BeautifulSoup(page, 'lxml')
        super().__init__(soup)

    def make_details_dict(self):
        if self.recipe_dict == {}:
            recipe_info_wrapper = self.soup.find_all('div', class_='recipe-info-section')
            if len(recipe_info_wrapper) == 0:
                return {'unavailable_page': True}
            recipe_info_elements = recipe_info_wrapper[0].find_all('div', class_='recipe-meta-item')

            for recipe_info in recipe_info_elements:
                name = recipe_info.find_all('div', class_='recipe-meta-item-header')[0].\
                        text.replace('\n', ' ').strip()[:-1]
                info = recipe_info.find_all('div', class_='recipe-meta-item-body')[0].text.replace('\n', ' ').strip()
                self.recipe_dict[name] = info

        return self.recipe_dict

    def extract_title(self):
        potential_titles = self.soup.find_all('h1', class_='headline heading-content')
        if len(potential_titles) != 0:
            return potential_titles[0].text.replace('\n', '').strip()
        else:
            return ""

    def extract_cooking_times(self):
        info_dict = self.make_details_dict()

        try:
            total_time_raw = info_dict['total']
            total_time = parse_time(total_time_raw)
        except KeyError:
            total_time = 0

        try:
            active_time_raw = info_dict['cook']
            active_time = parse_time(active_time_raw)
        except KeyError:
            active_time = total_time

        return active_time, total_time

    def extract_servings(self):
        info_dict = self.make_details_dict()
        try:
            servings_raw = info_dict['Servings']
            return parse_servings(servings_raw)
        except KeyError:
            return 0, 'servings'

    def extract_ingredients(self):
        ingredient_elements = self.soup.find_all('span', class_='ingredients-item-name')
        if len(ingredient_elements) == 0:
            return [], [], []

        ingredients = [ingredient.text.replace('\n', ' ').strip() for ingredient in ingredient_elements]
        for i in range(len(ingredients)):
            ingredients[i] = convert_unicode_to_string(ingredients[i])

        return itertools.repeat('', len(ingredients)), \
            itertools.repeat('', len(ingredients)), ingredients

    def extract_steps(self):
        step_wrapper = self.soup.find_all('ul', class_='instructions-section')
        if len(step_wrapper) == 0:
            return []

        step_elements = step_wrapper[0].find_all('p')
        if len(step_elements) == 0:
            return []

        return [element.text.strip() for element in step_elements]

    def extract_nutrition(self):
        try:
            nutrition = self.soup.find_all('section', class_='nutrition-section container')[0].\
                find_all('div', class_='section-body')[0].text.replace('\n', '').replace('Full Nutrition', '').strip()
        except IndexError:
            return [], []

        if nutrition[-1] == '.':
            nutrition = nutrition[:-1]

        nutrition_elements = nutrition.split(sep=';')

        nutrition_values = []
        nutrition_labels = []
        for element in nutrition_elements:
            elements = element.strip().split(sep=' ')
            label = ''
            value = ''
            for word in elements:
                if word.isalpha():
                    label += word + ' '
                else:
                    value += word
            nutrition_labels.append(label.strip())
            nutrition_values.append(value.strip())

        return nutrition_values, nutrition_labels

    def count_reviews(self):
        count_raw = self.soup.find_all('span', class_='review-headline-count')
        if len(count_raw) == 0:
            return -1
        return int(count_raw[0].text[1:][:-1])

    def extract_reviews(self):
        driver = webdriver.Chrome()
        review_count = self.count_reviews() - 10
        pages = int(review_count / 9)

        reviews = []
        ratings = []
        for i in range(2, pages):
            new_link = self.link + '?page=' + str(i)
            driver.get(new_link)
            WebDriverWait(driver, 3)

            review_body_elements = driver.find_elements_by_class_name('recipe-review-body')
            if len(review_body_elements) == 0:
                continue
            reviews_text = [review.text.replace('\n', ' ').strip() for review in review_body_elements][:9]

            rating_groups = driver.find_elements_by_class_name('review-star-text')
            if len(rating_groups) < 11:
                continue
            else:
                rating_groups = rating_groups[1:10]

            rating_text = [rating.text.replace('\n', '').replace('Rating: ', '').replace(' stars', '').strip()
                           for rating in rating_groups]

            reviews = reviews + reviews_text
            ratings = ratings + rating_text

        driver.close()

        return ratings, reviews

    def is_page_ok(self):
        response = self.make_details_dict()
        try:
            page_ok = response['unavailable_page']
            if page_ok:
                return False
        except KeyError:
            pass
        return True

    def extract_all(self):
        ok = self.is_page_ok()
        if not ok:
            return Recipe()
        recipe = Recipe()
        recipe.title = self.extract_title()
        recipe.steps.steps = self.extract_steps()
        recipe.active_time, recipe.total_time = self.extract_cooking_times()
        recipe.servings, recipe.serving_unit = self.extract_servings()
        recipe.ingredients.amounts, \
            recipe.ingredients.units, \
            recipe.ingredients.ingredients = self.extract_ingredients()
        recipe.nutrients.nutrient_values, recipe.nutrients.nutrient_labels = self.extract_nutrition()

        return recipe
