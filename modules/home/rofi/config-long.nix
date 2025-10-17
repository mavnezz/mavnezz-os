{...}: {
  home.file.".config/rofi/config-long.rasi".text = ''
    @import "~/.config/rofi/config.rasi"
    window {
      width: 600px;
      border-radius: 15px;
    }
    mainbox {
      orientation: vertical;
      children: [ "inputbar", "listbox" ];
    }
    inputbar {
      padding: 20px;
      background-color: @bg;
      text-color: @foreground;
      children: [ "textbox-prompt-colon", "entry" ];
    }
    textbox-prompt-colon {
      padding: 10px 16px;
      border-radius: 100%;
      background-color: @bg-alt;
      text-color: @foreground;
    }
    entry {
      expand: true;
      padding: 10px 14px;
      border-radius: 100%;
      background-color: @bg-alt;
      text-color: @foreground;
    }
    button {
      padding: 10px;
      border-radius: 100%;
    }
    element {
      spacing: 8px;
      padding: 10px;
      border-radius: 100%;
    }
    textbox {
      padding: 10px;
      border-radius: 100%;
    }
    error-message {
      border-radius: 0px;
    }
  '';
}
