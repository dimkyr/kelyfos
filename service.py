from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager

# Setup options for headless mode (optional)
chrome_options = Options()
chrome_options.add_argument("--headless")

# Initialize the Chrome WebDriver using webdriver-manager and a Service object
service = ChromeService(executable_path=ChromeDriverManager().install())
driver = webdriver.Chrome(service=service, options=chrome_options)

# Replace 'your_url_here' with the URL of the form page
url = 'your_url_here'
driver.get(url)
