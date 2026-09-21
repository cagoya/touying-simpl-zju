#import "@preview/touying:0.6.1": *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: edge, node
#import "./template/lib.typ": *

#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#set text(lang: "zh")
#show: zju-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  navigation: none,
  config-info(
    title: [Typst Slide Theme for ZJU Based on Touying],
    subtitle: [基于 Touying 的浙江大学 Typst 幻灯片模板],
    author: [求是学子],
    date: datetime.today(),
    institution: [浙江大学],
  ),
)

#title-slide()

#outline-slide()

= Typst 与 Touying

== Typst

Typst 是一门新的基于标记的排版系统，它强大且易于学习。本演示文稿不详细介绍 Typst 的使用，你可以在 Typst 的#link("https://typst.app/docs")[文档]中找到更多信息。

== Touying

Touying 是为 Typst 开发的幻灯片/演示文稿包。Touying 也类似于 LaTeX 的 Beamer，但是得益于 Typst，你可以拥有更快的渲染速度与更简洁的语法。你可以在 Touying 的#link("https://touying-typ.github.io/zh/docs/intro")[文档]中详细了解 Touying。

Touying 取自中文里的「投影」，在英文中意为 project。相较而言，LaTeX 中的 beamer 就是德文的投影仪的意思。

= Touying 幻灯片动画

== 简单动画

使用 ```typ #pause``` #pause 暂缓显示内容。

#pause

就像这样。

#meanwhile

同时，#pause 我们可以使用 ```typ #meanwhile``` 来 #pause 显示同时其他内容。

#speaker-note[
  使用 ```typ config-common(show-notes-on-second-screen: right)``` 来启用演讲提示，否则将不会显示。
]

== 复杂动画 - Mark-Style

在子幻灯片 #touying-fn-wrapper((self: none) => str(self.subslide)) 中，我们可以：

使用 #uncover("2-")[```typ #uncover``` 函数]（预留空间）

使用 #only("2-")[```typ #only``` 函数]（不预留空间）

#alternatives[多次调用 ```typ #only``` 函数 \u{2717}][使用 ```typ #alternatives``` 函数 #sym.checkmark] 从多个备选项中选择一个。


== 复杂动画 - Callback-Style

#slide(
  repeat: 3,
  self => [
    #let (uncover, only, alternatives) = utils.methods(self)

    在子幻灯片 #self.subslide 中，我们可以：

    使用 #uncover("2-")[```typ #uncover``` 函数]（预留空间）

    使用 #only("2-")[```typ #only``` 函数]（不预留空间）

    #alternatives[多次调用 ```typ #only``` 函数 \u{2717}][使用 ```typ #alternatives``` 函数 #sym.checkmark] 从多个备选项中选择一个。
  ],
)


== 数学公式动画

在 Touying 数学公式中使用 `pause`:

#touying-equation(
  `
  f(x)  &= pause x^2 + 2x + 1  \
        &= pause (x + 1)^2  \
`,
)

#meanwhile

如您所见，#pause 这是 $f(x)$ 的表达式。

#pause

通过因式分解，我们得到了结果。

= 与其他 Typst 包集成

== CeTZ 动画

在 Touying 中集成 CeTZ 动画：

#cetz-canvas({
  import cetz.draw: *

  rect((0, 0), (5, 5))

  (pause,)

  rect((0, 0), (1, 1))
  rect((1, 1), (2, 2))
  rect((2, 2), (3, 3))

  (pause,)

  line((0, 0), (2.5, 2.5), name: "line")
})


== Fletcher 动画

在 Touying 中集成 Fletcher 动画：

#fletcher-diagram(
  node-stroke: .1em,
  node-fill: gradient.radial(blue.lighten(80%), blue, center: (30%, 20%), radius: 80%),
  spacing: 4em,
  edge((-1, 0), "r", "-|>", `open(path)`, label-pos: 0, label-side: center),
  node((0, 0), `reading`, radius: 2em),
  edge((0, 0), (0, 0), `read()`, "--|>", bend: 130deg),
  pause,
  edge(`read()`, "-|>"),
  node((1, 0), `eof`, radius: 2em),
  pause,
  edge(`close()`, "-|>"),
  node((2, 0), `closed`, radius: 2em, extrude: (-2.5, 0)),
  edge((0, 0), (2, 0), `close()`, "-|>", bend: -40deg),
)

= 其他功能

== 重点页

#focus-slide[
  求是创新
]

== 双栏布局

#slide(composer: (1fr, 1fr))[
  大不自多，海纳江河；

  惟学无际，际于天地。

  形上谓道兮，形下谓器；

  礼主别异兮，乐主和同。
][
  知其不二兮，尔听斯聪；

  国有成均，在浙之滨；

  昔言求是，实启尔求真。

  习坎示教，始见经纶。
]


== 内容跨页

豫章故郡，洪都新府。星分翼轸，地接衡庐。襟三江而带五湖，控蛮荆而引瓯越。物华天宝，龙光射牛斗之墟；人杰地灵，徐孺下陈蕃之榻。雄州雾列，俊采星驰。台隍枕夷夏之交，宾主尽东南之美。都督阎公之雅望，棨戟遥临；宇文新州之懿范，襜帷暂驻。十旬休假，胜友如云；千里逢迎，高朋满座。腾蛟起凤，孟学士之词宗；紫电青霜，王将军之武库。家君作宰，路出名区；童子何知，躬逢胜饯。

时维九月，序属三秋。潦水尽而寒潭清，烟光凝而暮山紫。俨骖騑于上路，访风景于崇阿。临帝子之长洲，得天人之旧馆。层峦耸翠，上出重霄；飞阁流丹，下临无地。鹤汀凫渚，穷岛屿之萦回；桂殿兰宫，即冈峦之体势。

披绣闼，俯雕甍，山原旷其盈视，川泽纡其骇瞩。闾阎扑地，钟鸣鼎食之家；舸舰弥津，青雀黄龙之舳。云销雨霁，彩彻区明。落霞与孤鹜齐飞，秋水共长天一色。渔舟唱晚，响穷彭蠡之滨，雁阵惊寒，声断衡阳之浦。

// appendix by freezing last-slide-number
#show: appendix

== 附注 <touying:unoutlined>

#slide[
  - 本模板基于 Touying Dewdrop 主题与 touying-simpl-sjtu 模板开发。

  - 主题色为浙大蓝（求是蓝）`#003F88`，可通过 `primary` 参数自定义。
]

== 结束页 <touying:unoutlined>

#end-slide[
  感谢聆听

  Thanks for Listening!
]

#end-slide-blue[
  感谢聆听

  Thanks for Listening!
]
