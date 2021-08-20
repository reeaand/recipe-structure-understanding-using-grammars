import itertools
import mysql.connector


class RecipeDBHelper:
    config = {
        'user': 'root',
        'password': 'root123#',
        'host': '127.0.0.1',
        'port': '3306',
        'database': 'recipe_db',
        'raise_on_warnings': True,
        'auth_plugin': 'mysql_native_password'
    }

    def __init__(self):
        self.connection = mysql.connector.connect(**self.config)
        self.cursor = self.connection.cursor()

    def insert_recipe(self, title, website, link, total_time, active_time, servings, serving_unit, rating) -> int:
        insert_recipe_query = """
        INSERT INTO recipe
        (title, website, link, total_time, active_time, servings, serving_unit, rating)
        VALUES ( %s, %s, %s, %s, %s, %s, %s, %s)
        """
        values = (title, website, link, total_time, active_time, servings, serving_unit, rating)

        self.cursor.execute(insert_recipe_query, values)
        self.connection.commit()
        return self.cursor.lastrowid

    def insert_ingredients(self, recipe_id, amounts, units, ingredients):
        if not ingredients:
            return

        insert_ingredients_query = """
        INSERT INTO ingredient
        (cantity, unit, name, recipe_id)
        VALUES ( %s, %s, %s, %s)
        """
        values = list(zip(amounts, units, ingredients, itertools.repeat(recipe_id)))

        self.cursor.executemany(insert_ingredients_query, values)
        self.connection.commit()

    def insert_steps(self, recipe_id, steps):
        if not steps:
            return

        insert_steps_query = """
        INSERT INTO step
        (content, number, recipe_id)
        VALUES ( %s, %s, %s)
        """
        values = []
        for index in range(len(steps)):
            values.append((steps[index], index + 1, recipe_id))

        self.cursor.executemany(insert_steps_query, values)
        self.connection.commit()

    def insert_nutrients(self, recipe_id, nutrition_values, nutrition_labels):
        if not nutrition_labels:
            return

        insert_nutrients_query = """
        INSERT INTO nutrient
        (nutrient, value, recipe_id)
        VALUES ( %s, %s, %s)
        """
        values = list(zip(nutrition_labels, nutrition_values, itertools.repeat(recipe_id)))

        self.cursor.executemany(insert_nutrients_query, values)
        self.connection.commit()

    def insert_reviews(self, recipe_id, texts, ratings):
        if not texts:
            return

        insert_reviews_query = """
        INSERT INTO review
        (content, rating, recipe_id)
        VALUES ( %s, %s, %s)
        """

        values = list(zip(texts, ratings, itertools.repeat(recipe_id)))

        self.cursor.executemany(insert_reviews_query, values)
        self.connection.commit()

    def update_rating(self, recipe_id, new_rating):
        update_rating_query = """
                UPDATE review
                SET rating = %s
                WHERE recipe_id = %s
                """
        self.cursor.execute(update_rating_query, recipe_id, new_rating)
        self.connection.commit()

    def insert_all(self, recipe, w_reviews):
        recipe_id = self.insert_recipe(recipe.title, recipe.website, recipe.link,
                                       recipe.total_time, recipe.active_time, recipe.servings,
                                       recipe.serving_unit, recipe.rating)
        self.insert_steps(recipe_id, recipe.steps.steps)
        self.insert_ingredients(recipe_id, recipe.ingredients.amounts,
                                recipe.ingredients.units, recipe.ingredients.ingredients)
        self.insert_nutrients(recipe_id, recipe.nutrients.nutrition_values, recipe.nutrients.nutrition_labels)

        if w_reviews:
            self.insert_reviews(recipe_id, recipe.reviews.texts, recipe.reviews.ratings)

    def close(self):
        self.cursor.close()
        self.connection.close()
