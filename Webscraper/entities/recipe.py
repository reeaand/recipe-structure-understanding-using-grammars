class Steps:
    steps = []


class Ingredients:
    amounts = []
    units = []
    ingredients = []


class Nutrients:
    recipe_id = -1
    nutrition_values = []
    nutrition_labels = []


class Reviews:
    texts = []
    ratings = []


class Recipe:
    title = ''
    website = ''
    link = ''
    total_time = 0
    active_time = 0
    servings = 0
    serving_unit = 'servings'
    steps = Steps()
    ingredients = Ingredients()
    nutrients = Nutrients()
    reviews = Reviews()

    def print(self):
        print(self.title, self.website, self.link)
        print(self.total_time, self.active_time)
        print(self.servings, self.serving_unit)
        print(*self.steps.steps, sep='\n')
        print(*self.ingredients.ingredients, sep='\n')
        print(self.nutrients.nutrition_values)
        print(self.nutrients.nutrition_labels)





