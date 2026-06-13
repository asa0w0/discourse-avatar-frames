import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import { on } from "@ember/modifier";
import { fn } from "@ember/helper";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import Avatar from "discourse/components/avatar";

const eq = (a, b) => a === b;
const notEq = (a, b) => a !== b;

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

  <template>
    <div class="control-group avatar-frame-preferences">
      <label class="control-label">Avatar Rahmen</label>
      <div class="controls">
        <div class="avatar-frame-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 10px;">
          {{#each this.frames as |frame|}}
            <button 
              type="button" 
              class="btn btn-default avatar-frame-btn {{if (eq this.selectedFrame frame.id) 'btn-primary'}}"
              style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 10px; border-radius: 8px; width: 100%;"
              {{on "click" (fn this.selectFrame frame.id)}}
            >
              <div class="preview-avatar-wrapper" style="margin-bottom: 8px;">
                <div class="user-profile-avatar" style="position: relative; width: 45px; height: 45px;">
                  <Avatar @user={{this.currentUser}} @imageSize="large" />
                  {{#if (notEq frame.id "none")}}
                    <div class="avatar-frame-overlay frame-{{frame.id}}"></div>
                  {{/if}}
                </div>
              </div>
              <span class="frame-name" style="font-size: 0.85em; text-align: center;">{{frame.name}}</span>
            </button>
          {{/each}}
        </div>
        <div class="instructions" style="margin-top: 10px; font-size: 0.9em; color: var(--primary-medium);">
          Wähle einen animierten Rahmen für deinen Avatar aus. Die Änderung wird sofort gespeichert.
        </div>
      </div>
    </div>
  </template>
}
