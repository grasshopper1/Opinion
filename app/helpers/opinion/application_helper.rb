module Opinion
	module ApplicationHelper
		def bootstrap_error_messages!(object = resource)
			return '' if object.errors.empty?

			messages = object.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
			sentence = I18n.t('errors.messages.not_saved',
			                  count: object.errors.count,
			                  resource: object.class.model_name.human.downcase)

			html = <<-HTML
	<div class="alert alert-danger alert-block">
	   <button type="button" class="close" data-dismiss="alert">x</button>
	   <h5>#{sentence}</h4>
	   #{messages}
	</div>
			HTML

			html.html_safe
		end

		def bootstrap_messages!
			classes = %w(alert-block)
			if notice
				classes << 'alert'
				classes << 'alert-info'
				message = notice
			elsif alert
				classes << 'alert'
				classes << 'alert-warning'
				message = alert
			else
				return ''
			end

			html = <<-HTML
	<div class="#{classes.join(' ')}">
	   <button type="button" class="close" data-dismiss="alert">x</button>
	   #{message}
	</div>
			HTML

			html.html_safe
		end
	end
end
