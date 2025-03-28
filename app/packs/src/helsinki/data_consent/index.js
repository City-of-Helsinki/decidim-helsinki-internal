import { CookieConsentCore } from "hds-js";
import cookieSettings from "src/helsinki/data_consent/settings";

let instance = null;

const createInstance = async () => {
  const language = document.documentElement.getAttribute("lang") || "en";
  const settings = Object.assign(cookieSettings, { siteName: window.siteName });

  return await CookieConsentCore.create(settings, {
    language,
    theme: "black",
    targetSelector: "body",
    spacerParentSelector: "body",
    pageContentSelector: "body",
    submitEvent: true,
    settingsPageSelector: "div[data-consent-settings-page]",
    focusTargetSelector: null,
    disableAutoRender: false,
  });
}

export default async () => {
  if (instance !== null) {
    return instance;
  }

  instance = await createInstance();
  return instance;
};
