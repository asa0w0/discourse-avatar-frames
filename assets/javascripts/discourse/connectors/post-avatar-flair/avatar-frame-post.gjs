import Component from "@glimmer/component";
import { service } from "@ember/service";

export default class AvatarFramePost extends Component {
  @service currentUser;

  get frameClass() {
    const frame = this.args.outletArgs?.post?.user_avatar_frame || this.args.outletArgs?.user?.custom_fields?.avatar_frame;
    return frame ? `frame-${frame}` : null;
  }

  get disableAnimations() {
    const val = this.currentUser?.custom_fields?.disable_avatar_animations;
    return val === "true" || val === true;
  }

  <template>
    {{yield}}
    {{#if this.frameClass}}
      <div class="avatar-frame-overlay {{this.frameClass}} {{if this.disableAnimations 'no-animations'}}"></div>
    {{/if}}
  </template>
}
