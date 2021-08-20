from abc import abstractmethod, ABC


class AbstractRecipeExtractor(ABC):

    def __init__(self, soup):
        self.soup = soup

    @abstractmethod
    def extract_title(self):
        pass

    @abstractmethod
    def extract_cooking_times(self):
        pass

    @abstractmethod
    def extract_servings(self):
        pass

    @abstractmethod
    def extract_ingredients(self):
        pass

    @abstractmethod
    def extract_steps(self):
        pass

    @abstractmethod
    def extract_nutrition(self):
        pass

    @abstractmethod
    def extract_reviews(self):
        pass

    @abstractmethod
    def extract_all(self):
        self.extract_title()
        self.extract_steps()
        self.extract_servings()
        self.extract_nutrition()
        self.extract_ingredients()
