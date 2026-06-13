import Component from "@glimmer/component";

export default class AvatarFrameUserCard extends Component {
  get frameClass() {
    const frame = this.args.outletArgs?.user?.custom_fields?.avatar_frame;
    return frame ? `frame-${frame}` : null;
  }

  <template>
    {{#if this.frameClass}}
      <div class="avatar-frame-overlay {{this.frameClass}}"></div>
    {{/if}}
  </template>
}
