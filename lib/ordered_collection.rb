module OrderedCollection

  def order_collection_by(column, direction="ASC", options={})
    options.symbolize_keys!
    self.attr_accessor_with_default :reorder_collection, true
    self.class_inheritable_accessor :order_collection
    self.order_collection = {
        :column => column.to_s,
        :direction => direction.to_s,
        :parent => options[:parent]
    }

    self.before_save {|instance|
      instance.reorder_collection!(instance.changes[column]) if instance.reorder_collection and instance.changes[column]
    }
    self.after_destroy {|instance|
      instance.reorder_all!
    }
    self.default_scope :order => "#{column} #{direction.to_s.upcase}"

    if options[:new_instance].to_s == 'end'
      self.after_validation_on_create { |instance| instance.send("#{column}=", instance.class.count + 1) unless send(column) }
    else
      self.after_validation_on_create { |instance| instance.send("#{column}=",1) unless send(column) }
    end

    self.send :include, InstanceMethods
  end



  module InstanceMethods
    def reorder_all!
      order_collection_where.each_with_index do |p,i|
        p.reorder_collection= false
        p.update_attribute(order_collection[:column], i + 1)
      end
    end
    def reorder_collection!(changes)
      old_value = changes.first
      new_value= changes.last
      if old_value.nil?
        order_collection_where.each do |p|
          p.reorder_collection= false
          p.update_attribute(order_collection[:column], p.number.to_i+1)
        end
      elsif new_value > old_value
        order_collection_where(order_collection[:column] => (old_value+1..new_value)).each do |p|
          p.reorder_collection= false
          p.update_attribute(order_collection[:column], p.number.to_i-1)
        end
      else
        order_collection_where(order_collection[:column] => (new_value..old_value-1)).each do |p|
          p.reorder_collection= false
          p.update_attribute(order_collection[:column], p.number.to_i+1)
        end
      end
    end

    def order_collection_where(condition=nil)
      if self.class.order_collection[:parent]
        association_foreign_key = self.class.reflections.fetch(self.class.order_collection[:parent]).association_foreign_key
        scope = self.class.where({association_foreign_key => send(association_foreign_key)})
      else
        scope = self.class.where(nil)
      end
      scope.where(condition)
    end

  end


end

ActiveRecord::Base.send :extend, OrderedCollection