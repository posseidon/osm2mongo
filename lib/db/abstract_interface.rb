module DB
    module AbstractInterface
  
      class InterfaceNotImplementedError < NoMethodError
      end
  
      def self.included(klass)
        klass.send(:include, AbstractInterface::Methods)
        klass.send(:extend, AbstractInterface::Methods)
      end
  
      module Methods    

        def api_not_implemented(klass, method_name = nil)
          if method_name.nil?
            caller.first.match(/in \`(.+)\'/)
            method_name = $1
          end
          raise AbstractInterface::InterfaceNotImplementedError.new("#{klass.class.name} needs to implement '#{method_name}' for interface #{self.name}!")
        end
      end
  
    end
end