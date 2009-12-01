# Viewtastic #


## Installation ##

Install the gem

    gem install viewtastic

Load the gem in your `environment.rb` file

    config.gem "viewtastic"

## Usage ##

My presenters go into the `app/presenters` directory of the application so this is added to the load_path in Rails by default by Viewtastic.

### Presenters ###

A Presenter inherits from `Viewtastic::Base` and should use the `presents` method to declare presented objects.
    
    class CommentPresenter < Viewtastic::Base
      presents :comment
    end

This gives you several 'magic' methods:

* All attributes of comment with the prefix 'comment'. For instance: `comment_body`, `comment_post`, `comment_created_at`.
* `comment_dom_id` is the same as calling `dom_id(comment)` in a view.

If you want to skip the prefix and just have the attribute name, you can declare:
    
    presents :comment => [:body, :created_at]

and you get `presenter.body` and `presenter.created_at`.


Assuming you have a `Comment` model and your controller has a helper method `current_user` that returns the user currently logged in, you could make the following presenter to help in presenting products.

    class CommentPresenter < Viewtastic::Base
      presents :comment
      
      def dom_id
        comment_dom_id
      end
      
      def owner?
        controller.current_user.comments.include?(comment)
      end
      
      def links
        returning([]) do |links|
          links << link_to("Edit", [:edit, comment]) if owner?
          links << link_to("Reply", [:new, :comment]) if controller.current_user
        end
      end
    end

### Convenience ###

`each_with_presenter` is available on any `Array`, and it is designed to reuse a single Presenter instance and pass every element in the array as the presented object.

In your view (maybe `posts/show.html.erb`):
    
    <ul>
    <% @post.comments.each_with_presenter(CommentPresenter, :comment) do |comment| %>
      <li id="<%= comment.dom_id %>">
        <%= comment.body %>
        <%= comment.links %>
      </li>
    <% end %>
    </ul>

## Credits ##

* [ActivePresenter](http://github.com/giraffesoft/active_presenter) was the inspiration for this project and some of the presenter code was used from ActivePresenter.
* [Authlogic](http://github.com/binarylogic/authlogic) -- the Authlogic activation code is used to activate Viewtastic on each request.

## License ##


Copyright (c) 2009 Istvan Hoka, released under the MIT license
