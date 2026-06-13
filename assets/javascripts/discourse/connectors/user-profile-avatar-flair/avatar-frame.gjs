import Component from "@glimmer/component";

export default class AvatarFrameUserProfile extends Component {
  get frameClass() {
    const frame = this.args.outletArgs?.model?.custom_fields?.avatar_frame;
    return frame ? `frame-${frame}` : null;
  }

  <template>
    {{yield}}
    {{#if this.frameClass}}
      <div class="avatar-frame-overlay-scaler"><div class="avatar-frame-overlay {{this.frameClass}}"></div></div>
    {{/if}}
  </template>
}
