# SimpleRole

Magical Authorization for Rails. Supports ActiveAdmin, CanCanCan.

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

And edit `config/environments/development.rb` (if you manage AR models **manually**) :

```ruby
config.eager_load = true
```

Then edit `config/initializers/simple_role.rb` if you want :

```ruby
SimpleRole.configure do |config|
  # [Required:Hash]
  # == Role | default: { guest: 0, staff: 1, admin: 2 }
  config.roles = { guest: 0, staff: 1, admin: 2 }

  # [Optional:Array]
  # == Special roles which don't need to manage on database
  config.super_user_roles = [:admin]
  # == [RECOMMEND] avoid security problems
  config.guest_user_roles = [:guest]

  # [Optional:String]
  # == User class name | default: 'User'
  config.user_class_name = "User"

  # [Optional:Symbol]
  # == Default permission | default: :disabled
  # config.default_state = :disabled

  # [Optional:Boolean]
  # == Using Active Admin | default: true
  # config.using_active_admin = true
end
```

## Recipe

### ActiveAdmin and CanCanCan with Rails 5

1. Add gems to `Gemfile` and run `bundle install`

  ```ruby
  gem 'activeadmin', github: 'activeadmin'
  gem 'devise'
  gem 'cancancan'
  gem 'inherited_resources', github: 'activeadmin/inherited_resources'
  gem 'simple_role', github: 'yhirano55/simple_role'
  ```

2. Setup ActiveAdmin

        $ bin/rails g active_admin:install

3. Install SimpleRole

        $ bin/rails g simple_role:install --model AdminUser

4. Generate Ability Class for CanCanCan

        $ bin/rails g simple_role:cancan:ability

  And edit `config/initializers/active_admin.rb`

  ```ruby
  # == User Authorization
  #
  # Active Admin will automatically call an authorization
  # method in a before filter of all controller actions to
  # ensure that there is a user with proper rights. You can use
  # CanCanAdapter or make your own. Please refer to documentation.
  config.authorization_adapter = ActiveAdmin::CanCanAdapter
  ```

5. Generate Permission resource for ActiveAdmin

        $ bin/rails g simple_role:active_admin:resource

6. migrate and run

        $ bin/rails db:create db:migrate
        $ bin/rails runner 'AdminUser.create(email: "admin@example.com", password: "password", password_confirmation: "password", role: :admin)'
        $ bin/rails runner 'AdminUser.create(email: "staff@example.com", password: "password", password_confirmation: "password", role: :staff)'
        $ bin/rails s

7. visit `http://localhost:3000/admin` and login as **admin**

  ![](https://cloud.githubusercontent.com/assets/15371677/20375027/c5d6b04a-acbf-11e6-8c6c-943249841358.png)

8. visit `http://localhost:3000/admin/permissions` and click `reload` and edit permissions.

  ![image](https://cloud.githubusercontent.com/assets/15371677/20375052/efda8100-acbf-11e6-8b43-c7e170ef725a.png)

  ![image](https://cloud.githubusercontent.com/assets/15371677/20375076/0cc4e49a-acc0-11e6-8fd9-20e43ea7a16a.png)

9. change permission (enable something)

  ![image](https://cloud.githubusercontent.com/assets/15371677/20375131/7b484466-acc0-11e6-83a1-bd3777943008.png)

10. logout and login as **staff**

  ![image](https://cloud.githubusercontent.com/assets/15371677/20375154/9c856ece-acc0-11e6-87ab-468310629d20.png)

  user is staff can control allowed functions.

11. **Optional** If you want to implement interface on `AdminUser` for assigning each role to users, please copy [this code](https://github.com/yhirano55/simple_role/tree/master/lib/generators/simple_role/active_admin/templates/admin_user.rb) and paste it.

  ![](https://cloud.githubusercontent.com/assets/15371677/20375538/12f66a5c-acc3-11e6-974e-8a059c1702cc.png)

## License

[MIT License](http://opensource.org/licenses/MIT)
