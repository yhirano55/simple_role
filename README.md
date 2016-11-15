# SimpleRole

Magical Authorization for Rails. Supports Pundit, CanCan.

## Installation

If using bundler, first add 'simple_role' to your Gemfile:

```ruby
gem "simple_role", github: "yhirano55/simple_role"
```

And run

    bundle install

Otherwise simply

    gem install simple_role

## Rails configuration

    rails generate simple_role:install

And edit `config/environments/development.rb` (if you manage AR models) :

```ruby
config.eager_load = true
```

Then edit `config/initializers/simple_role.rb` if you want :

```ruby
SimpleRole.configure do |config|
  # == Manageable roles
  config.roles = { guest: 0, staff: 1, exstaff: 2, manager: 3, admin: 4 }

  # == Special roles (manage roles without using table)
  config.super_user_roles = [:admin]
  config.guest_user_roles = [:guest]

  # == Edit if you will use anything other name (e.g.: "AdminUser")
  config.user_class_name = "User"

  # == Default permission (:enabled or :disabled)
  config.default_permission = :disabled

  # == Authorization adapter (cancan or pundit)
  config.authorization_adapter = :cancan

  # == Using Active Admin
  config.using_active_admin = false

  # == Actions Dictinary
  config.action_dictionary = {
    index:   :read,
    show:    :read,
    new:     :create,
    create:  :create,
    edit:    :update,
    update:  :update,
    destroy: :destroy,
  }
end
```

## License

[MIT License](http://opensource.org/licenses/MIT)
