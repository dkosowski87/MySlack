module ApplicationHelper

	def title(title)
		content_for(:head) { content_tag :title, 'MySlack | ' + title }
		content_tag(:h3, title.titleize, class: 'page-title text-center')
	end

	def page_wrapper(&block)
		content_tag :div, class: 'row' do
			content_tag :div, capture(&block), class: 'small-8 small-centered columns large-4 large-centered columns'
		end
	end

	def standard_form(record, options={}, &block)
		options.merge! builder: StandardFormBuilder
		form_for(record, options, &block)
	end

end

