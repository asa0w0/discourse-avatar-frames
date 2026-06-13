import Component from "@glimmer/component";

export default class AvatarFramePost extends Component {
  get frameClass() {
    // In Glimmer <PostItem>, outletArgs typically provides `@post` or `@user`
    const frame = this.args.outletArgs?.post?.user_avatar_frame || this.args.outletArgs?.user?.custom_fields?.avatar_frame;
    return frame ? `frame-${frame}` : null;
  }

  <template>
    {{#if this.frameClass}}
      <div class="avatar-frame-overlay {{this.frameClass}}"></div>
    {{/if}}
  </template>
}
