import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

const AVAILABLE_FRAMES = [
  { id: "none", name: "Kein Rahmen" },
  { id: "vibrant-neon", name: "Neon Glow (Premium)" },
  { id: "cyber-glitch", name: "Cyberpunk Glitch" },
  { id: "gold-shimmer", name: "Gold Shimmer" },
  { id: "rgb-gamer", name: "RGB Gamer" },
  { id: "plasma-pulse", name: "Plasma Pulse" },
  { id: "sci-fi-dots", name: "Sci-Fi Dots" },
  { id: "breathing-ring", name: "Breathing Ring" },
  { id: "magma-edge", name: "Magma Edge" },
  { id: "holo-crystal", name: "Holo Crystal" },
  { id: "minimal-glow", name: "Minimal Glow" }
];

export default class AvatarFramePreferences extends Component {
  @service currentUser;
  @tracked selectedFrame = this.currentUser?.custom_fields?.avatar_frame || "none";
  frames = AVAILABLE_FRAMES;

  @action
  async selectFrame(frameId) {
    this.selectedFrame = frameId;
    
    const customFields = Object.assign({}, this.currentUser.custom_fields, { 
      avatar_frame: frameId === "none" ? null : frameId 
    });
    
    try {
      await ajax(`/users/${this.currentUser.username}.json`, {
        type: "PUT",
        data: { custom_fields: customFields }
      });
      // Update local current user
      this.currentUser.set("custom_fields", customFields);
    } catch (e) {
      popupAjaxError(e);
    }
  }
}
