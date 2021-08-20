import itertools
import re

from entities.recipe import Recipe
from scrapers.abstract_recipe_extractor import AbstractRecipeExtractor
from bs4 import BeautifulSoup

from utils.parsers.emoji import remove_emojis
from utils.parsers.servings_parser import parse_servings
from utils.parsers.time_parser import parse_time


class EpicuriousRecipeExtractor(AbstractRecipeExtractor):

    def __init__(self, page):
        soup = BeautifulSoup(page, 'lxml')
        super().__init__(soup)

    def extract_title(self):
        potential_titles = self.soup.find_all('h1')
        if len(potential_titles) != 0:
            return potential_titles[0].text.strip()
        else:
            return ""

    def extract_cooking_times(self):
        total_time_elements = self.soup.find_all('dd', class_='total-time')
        if len(total_time_elements) != 0:
            total_time_raw = total_time_elements[0].text.strip()
            total_time = parse_time(total_time_raw)
        else:
            total_time = 0

        active_time_elements = self.soup.find_all('dd', class_='active-time')
        if len(active_time_elements) != 0:
            active_time_raw = active_time_elements[0].text.strip()
            active_time = parse_time(active_time_raw)
        else:
            active_time = total_time

        return active_time, total_time

    def extract_servings(self):
        potential_servings = self.soup.find_all('dd', class_='yield')
        if len(potential_servings) != 0:
            servings_raw = potential_servings[0].text.strip()
            return parse_servings(servings_raw)
        else:
            return 0, 'servings'

    def extract_ingredients(self):
        ingredient_elements = self.soup.find_all(class_='ingredient')
        if len(ingredient_elements) == 0:
            return [], [], []

        ingredients = [ingredient.text.strip() for ingredient in ingredient_elements]

        # the split will be made in another stage for all sources
        return itertools.repeat('', len(ingredients)), itertools.repeat('', len(ingredients)), ingredients

    def extract_steps(self):
        step_elements = self.soup.find_all('li', class_="preparation-step")
        if len(step_elements) == 0:
            return []

        return [step.text.strip().replace('\n', ' ') for step in step_elements]

    def extract_nutrition(self):
        # this website doesn't provide nutrition
        return [], []

    def extract_rating(self):
        overall_rating_element = self.soup.find_all('span', class_='rating')
        if len(overall_rating_element) > 0:
            return overall_rating_element[0].text.strip().split('/')[0]
        else:
            return 0

    def extract_reviews(self):
        rating_images = self.soup.find_all(
            lambda tag: tag.name == 'img' and 'src' in tag.attrs
                        and 'static/img/recipe/ratings/' in tag.attrs['src'])
        if len(rating_images) == 0:
            return 0, [], []

        rating_elements = [re.findall(r'\d+', img['src'])[0] for img in rating_images]
        if len(rating_elements) < 2:
            return 0, [], []

        ratings = rating_elements[1:]

        review_elements = self.soup.find_all('div', class_='review-text')
        reviews = [review.find('p').text.replace('\n', ' ').strip() for review in review_elements]

        reviews = [remove_emojis(review) for review in reviews]

        return ratings, reviews

    def extract_all(self):
        recipe = Recipe()
        recipe.title = self.extract_title()
        recipe.rating = self.extract_rating()
        recipe.steps.steps = self.extract_steps()
        recipe.active_time, recipe.total_time = self.extract_cooking_times()
        recipe.servings, recipe.serving_unit = self.extract_servings()
        recipe.nutrients.nutrient_values, recipe.nutrients.nutrient_units = self.extract_nutrition()
        recipe.ingredients.amounts, \
            recipe.ingredients.units, \
            recipe.ingredients.ingredients = self.extract_ingredients()

        return recipe
