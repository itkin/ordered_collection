module OrderedCollection

  def order_collection_by(column)
      self.attr_accessor_with_default :reorder_collection, true
      self.class_inheritable_accessor :order_collection_column
      self.order_collection_column = column.to_s
      self.before_save {|instance|
        instance.class.reorder_collection!(instance.changes[column]) if instance.reorder_collection and instance.changes[column]
      }

    send :extend, ClassMethods
  end



  module ClassMethods
    def reorder_collection!(changes)
      old_value = changes.first
      new_value= changes.last
      if old_value.nil?
        all.each do |p|
          p.reorder_collection= false
          p.update_attribute(order_collection_column, p.number+1)
        end
      elsif new_value > old_value
        where(order_collection_column => (old_value+1..new_value)).each{|p|
          p.reorder_collection= false
          p.update_attribute(order_collection_column, p.number-1)
        }
      else
        where(order_collection_column => (new_value..old_value-1)).each{|p|
          p.reorder_collection= false
          p.update_attribute(order_collection_column, p.number+1)
        }
      end
    end
  end


end

ActiveRecord::Base.send :extend, OrderedCollection