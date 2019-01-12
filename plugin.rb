# name: discourse-flair
# about: A plugin to add user flair 
# version: 1.0.0
# author: trustrachel
# url: https://github.com/trustrachel/discourse-flair

enabled_site_setting :flair_enabled

DiscoursePluginRegistry.serialized_current_user_fields << "see_flair"
DiscoursePluginRegistry.serialized_current_user_fields << "flair"

after_initialize do

  User.register_custom_field_type('see_flair', :boolean)
  User.register_custom_field_type('flair', :text)

  register_editable_user_custom_field [:see_flair, :flair]

  if SiteSetting.flair_enabled then
    add_to_serializer(:post, :user_flair, false) {
      object.user.custom_fields['flair']
    }

    # I guess this should be the default @ discourse. PR maybe?
    add_to_serializer(:user, :custom_fields, false) {
      if object.custom_fields == nil then
        {}
      else
        object.custom_fields
      end
    }
  end
end

register_asset "javascripts/discourse/templates/connectors/user-custom-preferences/flair-preferences.hbs"
register_asset "stylesheets/common/flair.scss"
