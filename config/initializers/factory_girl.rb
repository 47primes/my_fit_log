module FactoryGirl
  class Registry
    
    def method_missing(symbol, *args)
      parent_name = symbol.to_s.match(/create_random_(\w+)/).to_a.last
      if parent_name
        random_child_of parent_name, *args
      else
        send(symbol, *args)
      end
    end
    
    private
    
    def random_child_of(parent_name, overrides = {}, &block)
      children = @items.values.select do |f| 
        f.send(:parent).respond_to?(:name) && f.send(:parent).name == parent_name.to_sym
      end.collect { |f| f.name.to_sym }
      FactoryGirl.create(children[rand(children.size)], overrides, &block)
    end
    
  end
end
