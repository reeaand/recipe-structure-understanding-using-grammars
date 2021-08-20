# from scrapers.epicurious.epicurious_scraper import EpicuriousScraper
from scrapers.allrecipes.allrecipes_scraper import AllrecipesScraper
import time

start_time = time.time()

# scraper = EpicuriousScraper()
# scraper.run(700, 1000, False)

scraperA = AllrecipesScraper()
scraperA.run(20, 50)

print(time.time() - start_time)
