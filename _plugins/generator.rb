module Jekyll
	class ICSGenerator < Generator
		def generate(site)
			events = site.data['schedule']
			events.each do |event|
				name = "#{event['title']}.ics"
				puts name
				page = Jekyll::ICS.new(site, site.source, @dir, name)
				site.pages << page
			end
		end
	end
	class ICS < Page
		def initialize(site, base, dir, name)
			@site = site
			@base = base
			@dir = dir
			@name = URI.encode_www_form_component(name)
			self.process(@name)
			self.data ||= {}
			self.data['layout'] = 'ics'
			require 'securerandom'
			self.data['uuid'] = SecureRandom.uuid
			self.data['title'] = name.rpartition('.').first
			event = site.data['schedule'].select { |event| event['title'] == self.data['title'] }[0]
			self.data['location'] = event['location']['name'] + " " + event['location']['address'].join(' ')
			self.data['time'] = event['time']
		end
	end
end