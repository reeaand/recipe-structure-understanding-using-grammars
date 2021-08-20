from selenium import webdriver


def speedup_selenium():
    option = webdriver.ChromeOptions()
    option = run_headless(option)
    option = dont_load_images(option)

    return option


def run_headless(option):
    option.add_argument("headless");
    option.add_argument("window-size=1200x600");

    return option


def dont_load_images(option):
    chrome_prefs = dict()
    option.experimental_options["prefs"] = chrome_prefs
    chrome_prefs["profile.default_content_settings"] = {"images": 2}
    chrome_prefs["profile.managed_default_content_settings"] = {"images": 2}

    return option
