import { withPluginApi } from "discourse/lib/plugin-api";
import RawHtml from "discourse/widgets/raw-html";

function attachFlair(api, siteSettings) {
  api.includePostAttributes("user_flair");

  api.decorateWidget("poster-name:after", dec => {
    const attrs = dec.attrs;
    if (Ember.isEmpty(attrs.user_flair)) {
      return;
    }

    const currentUser = api.getCurrentUser();
    if (currentUser) {
      const enabled = currentUser.get("custom_fields.see_flair");
      if (enabled) {
        return [
          dec.h("span.user-flair", {
            attributes: { src: attrs.user_flair }
          })
        ];
      }
    }
  });
}

export default {
  name: "extend-for-flair",
  initialize(container) {
    const siteSettings = container.lookup("site-settings:main");
    if (siteSettings.flair_enabled) {
      withPluginApi("0.1", api => attachFlair(api, siteSettings));
    }
  }
};
