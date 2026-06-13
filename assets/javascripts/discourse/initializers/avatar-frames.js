import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "avatar-frames-initializer",

  initialize(container) {
    withPluginApi("0.8.31", (api) => {
      // Decorate post avatars in the topic stream
      api.decorateWidget("post-avatar:after", (helper) => {
        const post = helper.getModel();
        // Sometimes getModel() doesn't return the post if it's a different context, so we check
        if (post && post.get("user_avatar_frame")) {
          const frameClass = `frame-${post.get("user_avatar_frame")}`;
          return helper.h("div.avatar-frame-overlay", {
            className: frameClass
          });
        }
      });
    });
  }
};
