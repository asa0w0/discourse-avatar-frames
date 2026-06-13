import Component from "@glimmer/component";

export default class AvatarFramePost extends Component {
  get frameClass() {
    const user = this.args.outletArgs?.user;
    const post = this.args.outletArgs?.post;
    const customFields = user?.custom_fields;
    console.log("[AVATAR-FRAMES] outletArgs:", { user, post, customFields });

    const frame = post?.user_avatar_frame || customFields?.avatar_frame;
    console.log("[AVATAR-FRAMES] Selected frame:", frame);
    
    // Fallback to test if CSS is the issue
    return frame ? `frame-${frame}` : "frame-vibrant-neon";
  }

  <template>
    {{yield}}
    {{#if this.frameClass}}
      <div class="avatar-frame-overlay {{this.frameClass}}"></div>
    {{/if}}
  </template>
}
