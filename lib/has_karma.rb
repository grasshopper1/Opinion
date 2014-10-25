module Opinion #:nodoc:
	module Karma #:nodoc:

		def self.included(base)
			base.extend ClassMethods
			class << base
				attr_accessor :karmic_objects
			end
		end

		module ClassMethods
			def has_karma(voteable_type, options = {})
				include Opinion::Karma::InstanceMethods
				extend  Opinion::Karma::SingletonMethods
				self.karmic_objects ||= {}
				self.karmic_objects[voteable_type.to_s.classify.constantize] = [ (options[:as] ? options[:as].to_s.foreign_key : self.name.foreign_key), [ (options[:weight] || 1) ].flatten.map(&:to_f) ]
			end
		end

		module SingletonMethods

			# Not yet implemented. Don't use it!
			# Find the most popular users
			# def find_most_karmic
			#   self.all
			# end

		end

		module InstanceMethods
			def karma(options = {})
				self.class.base_class.karmic_objects.collect do |object, attr|
					v = object.where(["#{self.class.base_class.table_name}.#{self.class.base_class.primary_key} = ?", self.id])
					v = v.joins("INNER JOIN #{Vote.table_name} ON #{Vote.table_name}.voteable_type = '#{object.to_s}' AND #{Vote.table_name}.voteable_id = #{object.table_name}.#{object.primary_key}")
					v = v.joins("INNER JOIN #{self.class.base_class.table_name} ON #{self.class.base_class.table_name}.#{self.class.base_class.primary_key} = #{object.table_name}.#{attr[0]}")
					upvotes = v.where(["#{Vote.table_name}.vote = ?", true])
					downvotes = v.where(["#{Vote.table_name}.vote = ?", false])
					if attr[1].length == 1 # Only count upvotes, not downvotes.
						(upvotes.count.to_f * attr[1].first).round
					else
						(upvotes.count.to_f * attr[1].first - downvotes.count.to_f * attr[1].last).round
					end
				end.sum
			end
		end
	end
end
