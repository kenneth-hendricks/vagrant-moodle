class BaseValidator
    
    def initialize(config)
        @config = config
    end
    
    def is_string?(var)
        if var.respond_to?(:to_str)
            return true;
        end
        puts "#{var} does not respond to to_str"
        return false
    end

    def array_contains_var?(array, var)
        if array.include?(var)
            return true
        end
        puts "#{var} is not in #{array}"
        return false
    end

    def is_int?(var)
        if var.respond_to?(:to_int)
            return true;
        end
        puts "#{var} does not respond to to_int"
        return false
    end

    def path_exists?(path)
        path = Pathname.new(path)
        if path.exist?
            return true
        end
        puts "Path #{path} does not exist"
        return false
    end
end

class DatabaseValidator < BaseValidator
    def validate()
        type = @config['type']
        allowedtypes = ['pgsql', 'mysql']
        unless array_contains_var?(allowedtypes, type)
            return false
        end

        name = @config['name']
        unless is_string?(name)
            return false
        end

        owner = @config['owner']
        unless is_string?(owner)
            return false
        end

        password = @config['password']
        unless is_string?(password)
            return false
        end

        return true
    end
end

class MoodleValidator < BaseValidator
    def validate()
        sitename = @config['sitename']
        unless is_string?(sitename)
            return false
        end

        adminuser = @config['adminuser']
        unless is_string?(adminuser)
            return false
        end

        adminpassword = @config['adminpassword']
        unless is_string?(adminpassword)
            return false
        end

        return true
    end
end

class VirtualboxValidator < BaseValidator
    def validate()
        memory = @config['memory']
        unless is_int?(memory)
            return false
        end

        cores = @config['cores']
        unless is_int?(cores)
            return false
        end

        return true
    end
end

class BoxEnvironmentValidator < BaseValidator
    def validate()
        base = @config['base']
        allowedbases = ['ubuntu/trusty64', 'ubuntu/xenial64']
        unless array_contains_var?(allowedbases, base)
            return false
        end

        name = @config['name']
        unless is_string?(name)
            return false
        end

        name = @config['name']
        unless is_string?(name)
            return false
        end

        phpversion = @config['phpversion']
        allowedphps = [5, 7]
        unless array_contains_var?(allowedphps, phpversion)
            return false
        end

        return true
    end
end

class WebserverValidator < BaseValidator
    def validate()
        
        type = @config['type']
        allowedtypes = ['apache', 'nginx']
        unless array_contains_var?(allowedtypes, type)
            return false
        end
        return true
    end
end

class SiterootValidator < BaseValidator
    def validate()
        hostpath = @config['hostpath']
        unless path_exists?(hostpath)
            return false
        end

        vmpath = @config['vmpath']
        #no validation as of yet

        return true
    end
end


def validate_config(config)
    validators = []
    validators.push(DatabaseValidator.new(config['database']))
    validators.push(MoodleValidator.new(config['moodle']))
    validators.push(VirtualboxValidator.new(config['virtualbox']))
    validators.push(BoxEnvironmentValidator.new(config['boxenvironment']))
    validators.push(WebserverValidator.new(config['webserver']))
    validators.push(SiterootValidator.new(config['siteroot']))

    validators.each { |v| 
        unless v.validate
            puts "#{v.class.name} return false. Exiting"
            exit
        end
    }

end

