class StandardFormBuilder < ActionView::Helpers::FormBuilder
	include ActionView::Helpers::TagHelper
	include ActionView::Helpers::CaptureHelper
	include ActionView::Context

	%w(text_field password_field email_field text_area).each do |field|
		define_method field.to_sym do |method, options={}|
			options['aria-describedby'] = "#{method}HelpText"
			label(method) + super(method, options) + errors_display(method)
		end
	end

	def submit(value, options={})
		options[:class] = 'expanded button' if options[:class].nil?
		super
	end

	def fieldset(*fields, legend_text: nil) 
		fields_in_set = capture { content_tag(:legend, legend_text) }
		fields.each do |field|
			fields_in_set += capture { field }
		end
		content_tag :fieldset, class: 'fieldset' do
			fields_in_set
		end
	end

	def errors_display(attribute)
		if object.errors[attribute].any?
			msgs = object.errors[attribute].join(" ")
			content_tag :p, msgs, class: 'help-text', id: "#{attribute}HelpText"
		end
	end

end