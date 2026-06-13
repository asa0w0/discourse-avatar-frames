import Component from "@glimmer/component";

export default class AvatarFrameUserProfile extends Component {
  get frameClass() {
    const frame = this.args.outletArgs?.user?.custom_fields?.avatar_frame;
    return frame ? `frame-${frame}` : null;
  }
}
