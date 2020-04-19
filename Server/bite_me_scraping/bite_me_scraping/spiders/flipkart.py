# -*- coding: utf-8 -*-
import scrapy
from selenium import webdriver

class FlipkartSpider(scrapy.Spider):
	name = 'flipkart'
	allowed_domains = ['flipkart.com']
	start_urls = ['https://www.flipkart.com/protein-supplements/pr?sid=7jv,owt,d9u&otracker=categorytree']

	def parse(self, response):
		productUrls = response.xpath('//a[contains(@class, "_2cLu-l")]/@href').extract()
		for productpage in productUrls:
			yield scrapy.Request('https://www.' + self.allowed_domains[0] + productpage, callback=self.parse_product)

	def parse_product(self, response):
		name = response.xpath('//span[contains(@class, "_35KyD6")]/text()').extract()[0]
		description = response.xpath('//div[contains(@class, "_3la3Fn")]/text()').extract()[0]
		price = ''.join(response.xpath('//div[contains(@class, "_1vC4OE") or contains(@class, "_3qQ9m1")]/text()').extract()[0][1:].split(','))
		
		driver = webdriver.Firefox(executable_path='/mnt/c/Program Files/Mozilla Firefox/geckodriver.exe')
		driver.get(response.url)
		#driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
		imageUrl = driver.find_element_by_xpath('//img[contains(@class, "_1Nyybr")]').get_attribute('src')
		driver.close()
		driver.quit()

		return {'name':name, 'description':description, 'price':price, 'imageUrl':imageUrl, 'link': response.url}
