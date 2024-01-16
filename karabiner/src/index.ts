import {
  ModificationParameters,
  map,
  rule,
  simlayer,
  writeToProfile,
} from "karabiner.ts"

const rules = [
  rule("caps lock -> left_control + esacpe").manipulators([
    map("caps_lock").to("left_control").toIfAlone("escape"),
  ]),

  simlayer("f", "layer-2-mode").manipulators([
    map("h").to("left_arrow"),
    map("j").to("down_arrow"),
    map("k").to("up_arrow"),
    map("l").to("right_arrow"),

    map("u").to("8", ["right_option", "right_shift"]), // {
    map("i").to("9", ["right_option", "right_shift"]), // }
    map("n").to("8", "right_option"), // [
    map("m").to("9", "right_option"), // ]
    map("o").to("8", "left_shift"), // (
    map("p").to("9", "left_shift"), // )
    map("y").to("7", "left_option"), // |
    map("s").to("7", "left_shift"), // /
    map("b").to("7", ["right_option", "right_shift"]), // \
  ]),
]

const params: ModificationParameters = {
  "basic.simultaneous_threshold_milliseconds": 50,
  "basic.to_if_alone_timeout_milliseconds": 500,
}

writeToProfile("k7r", rules, params)
