import Component from "@glimmer/component";
import { service } from "@ember/service";
import { isAnimationsDisabled } from "../../lib/avatar-frame-utils";

export default class AvatarFrameUserProfile extends Component {
  @service currentUser;

  get frameClass() {
    const frame = this.args.outletArgs?.model?.custom_fields?.avatar_frame;
    return frame ? `frame-${frame}` : null;
  }

  get disableAnimations() {
    return isAnimationsDisabled(this.currentUser);
  }

  <template>
    {{yield}}
    {{#if this.frameClass}}
      <div class="avatar-frame-overlay {{this.frameClass}} {{if this.disableAnimations 'no-animations'}}"></div>
    {{/if}}
  </template>
}
