# modeled closely after
# https://github.com/opscode/chef/blob/master/lib/chef/dsl/recipe.rb
# and https://github.com/opscode/chef/blob/master/lib/chef/recipe.rb

class Chef
  class Recipe

    #  edits an existing resource if it exists,
    #  creates it if the resource doesn't already exist
    #  For example:
        #      #  recipe postgresql::server defines user "postgres"
    #      and
    #      #  sets the home directory to /var/pgsql/9.2
    #      include_recipe "postgresql::user"
    #
    #      edit "user[postgres]" do
    #          home "/home/postgres"
    #      end
    # === Parameters
    # resource<String>:: String identifier for resource
    # block<Proc>:: Block with attributes to edit or create
    def edit(resource_id, &block)
      begin
        r = resources(resource_id)
        Chef::Log.info "Resource #{resource_id} found, now editing it"
        r.instance_exec(&block) if block
      rescue Chef::Exceptions::ResourceNotFound
        Chef::Log.info "Resource #{resource_id} not found, so creating
                                #from scratch"
        resource_id =~ /^([^\[]*)\[(.*)\]$/
        method_symbol = $1.to_sym
        resource_name = $2
        self.send(method_symbol, resource_name, &block)
      end
    end
  end
end

