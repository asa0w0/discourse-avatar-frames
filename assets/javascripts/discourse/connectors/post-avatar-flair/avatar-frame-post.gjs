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
      <div 
        class="avatar-frame-overlay {{this.frameClass}}"
        style="position: absolute; top: -10%; left: -10%; width: 120%; height: 120%; border-radius: 50%; pointer-events: none; z-index: 999; border: 5px solid lime; background: rgba(0, 255, 0, 0.3);">
      </div>
    {{/if}}
  </template>
}
