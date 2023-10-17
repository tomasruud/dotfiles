import {
  map,
  rule,
  withModifier,
  writeToProfile,
} from "karabiner.ts"

const rules = [
  rule("caps lock modifiers").manipulators([
    map("caps_lock").toHyper().toIfAlone("escape"),
  ]),

  rule("hyper modifiers").manipulators([
    withModifier("Hyper")([
      map("h").to("left_arrow"),
      map("j").to("down_arrow"),
      map("k").to("up_arrow"),
      map("l").to("right_arrow"),

      map("0").to("9", ["right_option", "right_shift"]), // {
      map("7").to("8", ["right_option", "right_shift"]), // }
      map("8").to("8", "right_option"), // [
      map("9").to("9", "right_option"), // ]
      map("6").to("7", "left_option") // |
    ]),
  ]),
]

writeToProfile("k7r", rules)
