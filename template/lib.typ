// Touying Slide Theme for Zhejiang University (ZJU)
// Based on the Touying Dewdrop theme (https://touying-typ.github.io/docs/themes/dewdrop)
// and touying-simpl-sjtu (https://github.com/tzhTaylor/touying-sjtu)

#import "@preview/touying:0.6.1": *

#let _typst-builtin-repeat = repeat

// ZJU brand color: 求是蓝 (C100 M80 Y0 K0)
#let zju-blue = rgb("#003F88")

#let mini-slides(
  self: none,
  fill: rgb("000000"),
  alpha: 60%,
  display-section: false,
  display-subsection: true,
  linebreaks: true,
  short-heading: true,
) = (
  context {
    let headings = query(heading.where(level: 1).or(heading.where(level: 2)))
    let sections = headings.filter(it => it.level == 1)
    if sections == () {
      return
    }
    let first-page = sections.at(0).location().page()
    headings = headings.filter(it => it.location().page() >= first-page)
    let slides = query(<touying-metadata>).filter(it => (
      utils.is-kind(it, "touying-new-slide") and it.location().page() >= first-page
    ))
    let current-page = here().page()
    let current-index = sections.filter(it => it.location().page() <= current-page).len() - 1
    let cols = ()
    let col = ()
    for (hd, next-hd) in headings.zip(headings.slice(1) + (none,)) {
      if hd.outlined == false {
        continue
      }

      let next-page = if next-hd != none {
        next-hd.location().page()
      } else {
        calc.inf
      }
      if hd.level == 1 {
        if col != () {
          cols.push(align(left, col.sum()))
          col = ()
        }
        col.push({
          let body = if short-heading {
            utils.short-heading(self: self, hd)
          } else {
            hd.body
          }
          [#link(hd.location(), body)<touying-link>]
          linebreak()
          while slides.len() > 0 and slides.at(0).location().page() < next-page {
            let slide = slides.remove(0)
            if display-section {
              let next-slide-page = if slides.len() > 0 {
                slides.at(0).location().page()
              } else {
                calc.inf
              }
              if slide.location().page() <= current-page and current-page < next-slide-page {
                [#link(slide.location(), sym.circle.filled)<touying-link>]
              } else {
                [#link(slide.location(), sym.circle)<touying-link>]
              }
            }
          }
          if display-section and display-subsection and linebreaks {
            linebreak()
          }
        })
      } else {
        col.push({
          while slides.len() > 0 and slides.at(0).location().page() < next-page {
            let slide = slides.remove(0)
            if display-subsection {
              let next-slide-page = if slides.len() > 0 {
                slides.at(0).location().page()
              } else {
                calc.inf
              }
              if slide.location().page() <= current-page and current-page < next-slide-page {
                [#link(slide.location(), sym.circle.filled)<touying-link>]
              } else {
                [#link(slide.location(), sym.circle)<touying-link>]
              }
            }
          }
          if display-subsection and linebreaks {
            linebreak()
          }
        })
      }
    }
    if col != () {
      cols.push(align(left, col.sum()))
      col = ()
    }
    if current-index < 0 or current-index >= cols.len() {
      cols = cols.map(body => text(fill: fill, body))
    } else {
      cols = cols
        .enumerate()
        .map(pair => {
          let (idx, body) = pair
          if idx == current-index {
            text(fill: fill, body)
          } else {
            text(fill: utils.update-alpha(fill, alpha), body)
          }
        })
    }
    set align(top)
    show: block.with(inset: (top: .5em, x: 2em))
    show linebreak: it => it + v(-1em)
    set text(size: .7em)
    grid(columns: cols.map(_ => auto).intersperse(1fr), ..cols.intersperse([]))
  }
)

#let _get-last-heading-depth(current-headings) = {
  if current-headings != () {
    current-headings.at(-1).depth
  } else {
    0
  }
}

#let _get-last-heading-label(current-headings) = {
  if current-headings != () {
    if current-headings.at(-1).has("label") {
      str(current-headings.at(-1).label)
    }
  }
}

#let zju-header(self) = {
  let last-heading-depth = _get-last-heading-depth(self.headings)
  let last-heading-label = _get-last-heading-label(self.headings)
  if self.store.navigation == "sidebar" {
    place(right + top, {
      v(4em)
      show: block.with(width: self.store.sidebar.width, inset: (x: 1em))
      set align(left)
      set par(justify: false)
      set text(size: .9em)
      components.custom-progressive-outline(
        self: self,
        level: auto,
        alpha: self.store.alpha,
        text-fill: (self.colors.primary, self.colors.neutral-darkest),
        text-size: (1em, .9em),
        vspace: (-.2em,),
        indent: (0em, self.store.sidebar.at("indent", default: .5em)),
        fill: (self.store.sidebar.at("fill", default: _typst-builtin-repeat[.]),),
        filled: (self.store.sidebar.at("filled", default: false),),
        paged: (self.store.sidebar.at("paged", default: false),),
        short-heading: self.store.sidebar.at("short-heading", default: true),
      )
    })
  } else if self.store.navigation == "mini-slides" {
    mini-slides(
      self: self,
      fill: self.colors.primary,
      alpha: self.store.alpha,
      display-section: self.store.mini-slides.at("display-section", default: false),
      display-subsection: self.store.mini-slides.at("display-subsection", default: true),
      linebreaks: self.store.mini-slides.at("linebreaks", default: true),
      short-heading: self.store.mini-slides.at("short-heading", default: true),
    )
    grid(
      inset: (x: 1.9em),
      rows: (1fr, 2fr),
      row-gutter: 5%,
      grid(
        columns: (75%, 25%),
        [
          #set text(size: 16pt)
          #align(left + horizon, utils.display-current-heading(
            depth: if last-heading-label == "touying:hidden" { self.slide-level - 1 } else { self.slide-level },
            style: none,
          ))
        ],
        align(right + horizon, image("assets/zju-emblem.png", height: 0.9cm)),
      ),
      align(center + top, line(length: 100%, stroke: (paint: self.colors.primary, thickness: 1.5pt))),
    )
  } else {
    grid(
      inset: (x: 1.9em),
      rows: (auto, auto),
      row-gutter: 15%,
      grid(
        columns: (75%, 25%),
        [
          #set text(size: 16pt)
          #align(left + horizon, utils.display-current-heading(
            depth: if last-heading-label == "touying:hidden" { self.slide-level - 1 } else { self.slide-level },
            style: none,
          ))
        ],
        align(right + horizon, image("assets/zju-emblem.png", height: 0.9cm)),
      ),
      align(center + horizon, line(length: 100%, stroke: (paint: self.colors.primary, thickness: 1.5pt))),
      v(1em),
    )
  }
}

#let zju-footer(self) = {
  set align(bottom)
  set text(size: if self.appendix { 0em } else { 0.8em })
  show: pad.with(.5em)
  components.left-and-right(
    block(inset: (left: 0.5em, bottom: 0.5em), text(
      fill: self.colors.neutral-darkest.lighten(40%),
      size: 0.7em,
      utils.call-or-display(self, self.store.footer),
    )),
    block(inset: (right: 0.5em, bottom: 0.5em), text(
      fill: self.colors.neutral-darkest.lighten(20%),
      utils.call-or-display(self, self.store.footer-right),
    )),
  )
}

// Decorative background for the light title/end slides: translucent
// concentric circles in ZJU blue at the bottom-left corner.
#let _zju-title-background(self) = {
  place(left + bottom, dx: -8%, dy: 35%, circle(radius: 16em, fill: self.colors.primary.transparentize(94%)))
  place(left + bottom, dx: -12%, dy: 45%, circle(radius: 12em, fill: self.colors.primary.transparentize(90%)))
  place(right + top, dx: 10%, dy: -40%, circle(radius: 10em, fill: self.colors.primary.transparentize(94%)))
  place(bottom, rect(width: 100%, height: 0.35em, fill: gradient.linear(
    self.colors.primary,
    self.colors.primary.lighten(55%),
  )))
}

/// Default slide function for the presentation.
///
/// - config (dictionary): The configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For more several configurations, you can use `utils.merge-dicts` to merge them.
///
/// - repeat (int, auto): The number of subslides. Default is `auto`, which means touying will automatically calculate the number of subslides.
///
/// - setting (function): The setting of the slide. You can use it to add some set/show rules for the slide.
///
/// - composer (function, array): The composer of the slide. You can use it to set the layout of the slide.
///
///   For example, `#slide(composer: (1fr, 2fr, 1fr))[A][B][C]` to split the slide into three parts.
///
/// - bodies (array): The contents of the slide. You can call the `slide` function with syntax like `#slide[A][B][C]` to create a slide.
#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let self = utils.merge-dicts(
    self,
    config-page(header: zju-header, footer: zju-footer, margin: (x: 1.25cm)),
    config-common(subslide-preamble: self.store.subslide-preamble),
  )
  touying-slide(self: self, config: config, repeat: repeat, setting: setting, composer: composer, ..bodies)
})


/// Title slide for the presentation. You should update the information in the `config-info` function. You can also pass the information directly to the `title-slide` function.
///
/// Example:
///
/// ```typst
/// #show: zju-theme.with(
///   config-info(
///     title: [Title],
///   ),
/// )
///
/// #title-slide(subtitle: [Subtitle], extra: [Extra information])
/// ```
///
/// - config (dictionary): The configuration of the slide.
///
/// - extra (string, none): The extra information you want to display on the title slide.
#let title-slide(
  config: (:),
  extra: none,
  ..args,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config, config-common(freeze-slide-counter: true), config-page(
    header: align(right + horizon, block(inset: (right: 0.5em, top: 1.2em), image("assets/zju-logo.png", height: 1.6cm))),
    margin: (top: 3.5em, bottom: 1.5em, x: 2em),
  ))
  let info = self.info + args.named()
  let body = {
    set par(leading: 1.6em)
    set align(center + horizon)
    set page(background: _zju-title-background(self))
    block(width: 100%, inset: 3em, {
      v(0.2fr)
      block(
        if info.subtitle == none {
          linebreak()
        }
          + text(
            size: if info.subtitle == none { 2.2em } else { 1.9em },
            fill: self.colors.primary,
            weight: "bold",
            info.title,
          )
          + (
            if info.subtitle != none {
              linebreak()
              text(
                size: 1.3em,
                fill: self.colors.primary,
                weight: "bold",
                info.subtitle,
              )
            }
          ),
      )
      v(1fr)
      set text(size: 1.1em, fill: self.colors.neutral-dark, weight: "medium")
      if info.author != none {
        block(spacing: 1em, info.author)
      }
      v(1em)
      if info.date != none {
        block(spacing: 1em, utils.display-info-date(self))
      }
      set text(size: .8em)
      if info.institution != none {
        block(spacing: 1em, info.institution)
      }
      if extra != none {
        block(spacing: 1em, extra)
      }
      v(0.3fr)
    })
  }
  touying-slide(self: self, body)
})

/// Outline slide for the presentation.
///
/// - config (dictionary): The configuration of the slide.
///
/// - title (string): The title of the slide. Default is `utils.i18n-outline-title`.
#let outline-slide(config: (:), title: utils.i18n-outline-title, ..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-common(freeze-slide-counter: true), config-page(footer: zju-footer, margin: (
    top: 3em,
  )))
  touying-slide(self: self, config: config, components.adaptive-columns(
    start: text(1.7em, fill: self.colors.primary, weight: "bold", utils.call-or-display(self, title) + v(0.5em)),
    text(fill: self.colors.neutral-darkest, outline(title: none, indent: 1em, depth: self.slide-level, ..args)),
  ))
})


#let new-section-mini-slides(
  self: none,
  fill: rgb("000000"),
  alpha: 60%,
  display-section: false,
  display-subsection: true,
  linebreaks: true,
  short-heading: true,
) = (
  context {
    let headings = query(heading.where(level: 1).or(heading.where(level: 2)))
    let sections = headings.filter(it => it.level == 1)
    if sections == () {
      return
    }
    let first-page = sections.at(0).location().page()
    headings = headings.filter(it => it.location().page() >= first-page)
    let slides = query(<touying-metadata>).filter(it => (
      utils.is-kind(it, "touying-new-slide") and it.location().page() >= first-page
    ))
    let current-page = here().page()
    let current-index = sections.filter(it => it.location().page() <= current-page).len() - 1
    let cols = ()
    let col = ()
    for (hd, next-hd) in headings.zip(headings.slice(1) + (none,)) {
      if hd.outlined == false {
        continue
      }

      let next-page = if next-hd != none {
        next-hd.location().page()
      } else {
        calc.inf
      }
      if hd.level == 1 {
        if col != () {
          cols.push(align(left, col.sum()))
          col = ()
        }
        col.push({
          let body = if short-heading {
            utils.short-heading(self: self, hd) + linebreak()
          } else {
            hd.body + linebreak()
          }
          [#link(hd.location(), body)<touying-link>]
          linebreak()
          while slides.len() > 0 and slides.at(0).location().page() < next-page {
            let slide = slides.remove(0)
            if display-section {
              let next-slide-page = if slides.len() > 0 {
                slides.at(0).location().page()
              } else {
                calc.inf
              }
              if slide.location().page() <= current-page and current-page < next-slide-page {
                [#link(slide.location(), sym.circle.filled)<touying-link>]
              } else {
                [#link(slide.location(), sym.circle)<touying-link>]
              }
            }
          }
          if display-section and display-subsection and linebreaks {
            linebreak()
          }
        })
      } else {
        col.push({
          while slides.len() > 0 and slides.at(0).location().page() < next-page {
            let slide = slides.remove(0)
            if display-subsection {
              if hd.level == 2 {
                let next-slide-page = if slides.len() > 0 {
                  slides.at(0).location().page()
                } else {
                  calc.inf
                }
                if slide.location().page() <= current-page {
                  [#link(slide.location(), text(
                    size: .7em,
                    v(0em) + box(height: 0.8em, sym.circle.filled) + "  " + hd.body,
                  ))]
                } else {
                  [#link(slide.location(), text(size: .7em, v(0em) + box(height: 0.8em, sym.circle) + "  " + hd.body))]
                }
              }
            }
          }
          if display-subsection and linebreaks {
            linebreak()
          }
        })
      }
    }
    if col != () {
      cols.push(align(left, col.sum()))
      col = ()
    }
    if current-index < 0 or current-index >= cols.len() {
      cols = cols.map(body => text(fill: fill, body))
    } else {
      cols = cols
        .enumerate()
        .map(pair => {
          let (idx, body) = pair
          if idx == current-index {
            text(fill: fill, size: 1.1em, body)
          } else {
            text(fill: utils.update-alpha(fill, alpha), body)
          }
        })
    }
    set align(top)
    show: block.with(inset: (top: .5em, x: 2em))
    show linebreak: it => it + v(-1em)
    set text(size: .7em)
    grid(columns: cols.map(_ => auto).intersperse(1fr), ..cols.intersperse([]))
  }
)

/// New section slide for the presentation. You can update it by updating the `new-section-slide-fn` argument for `config-common` function.
///
/// Example: `config-common(new-section-slide-fn: new-section-slide.with(numbered: false))`
///
/// - config (dictionary): The configuration of the slide.
///
/// - title (string): The title of the slide. Default is `utils.i18n-outline-title`.
///
/// - body (array): The contents of the slide.
#let new-section-slide(config: (:), title: utils.i18n-outline-title, ..args, body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-page(
    header: grid(
      inset: (x: 1.9em),
      rows: (auto, auto),
      row-gutter: 15%,
      grid(
        columns: (1fr, 35%),
        align(left + horizon, text(size: 1.9em, utils.display-current-heading(depth: self.slide-level, style: auto))),
        align(right + horizon, image("assets/zju-emblem.png", height: 1.5cm)),
      ),
      v(-2cm),
      align(center + horizon, line(length: 100%, stroke: (paint: self.colors.primary, thickness: 1.5pt))),
    ),
    footer: zju-footer,
    margin: (top: 8cm, left: 0cm),
  ))
  touying-slide(self: self, config: config, components.adaptive-columns(text(
    hyphenate: false,
    size: 1.2em,
    fill: self.colors.neutral-darkest,
    new-section-mini-slides(
      self: self,
      fill: self.colors.primary,
      alpha: self.store.alpha,
      display-section: false,
      display-subsection: true,
      linebreaks: false,
      short-heading: true,
    ),
  )))
})


/// Focus on some content.
///
/// Example: `#focus-slide[Wake up!]`
///
/// - config (dictionary): The configuration of the slide.
#let focus-slide(config: (:), body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-common(freeze-slide-counter: true), config-page(
    fill: self.colors.primary,
    margin: 2em,
  ))
  set text(fill: self.colors.neutral-lightest, size: 1.5em)
  touying-slide(self: self, config: config, align(horizon + center, body))
})


/// End slide with the ZJU logo on a light background.
#let end-slide(config: (:), body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true, new-section-slide-fn: none),
    config-page(
      margin: 2em,
    ),
  )
  set text(fill: self.colors.primary, size: 1.65em, weight: "bold")
  let body = {
    set page(background: _zju-title-background(self))
    block(width: 90%, grid(
      columns: (45%, 1fr),
      column-gutter: 1em,
      align(horizon, image("assets/zju-logo.png", width: 100%)), align(horizon + left, body),
    ))
  }
  touying-slide(self: self, config: config, align(horizon + center, body))
})


/// End slide on a full ZJU-blue background with the white logo.
#let end-slide-blue(config: (:), body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-common(freeze-slide-counter: true, new-section-slide-fn: none), config-page(
    fill: self.colors.primary,
    margin: 2em,
  ))
  set text(fill: self.colors.neutral-lightest, size: 1.75em, weight: "bold")
  let body = {
    v(1fr)
    image("assets/zju-emblem-text-white.png", height: 30%)
    v(0.5em)
    body
    v(1.25fr)
  }
  touying-slide(self: self, config: config, align(horizon + center, body))
})

/// Touying ZJU theme.
///
/// Example:
///
/// ```typst
/// #show: zju-theme.with(aspect-ratio: "16-9")
/// ```
///
/// The default colors:
///
/// ```typ
/// config-colors(
///   neutral-darkest: rgb("#000000"),
///   neutral-dark: rgb("#202020"),
///   neutral-light: rgb("#f3f3f3"),
///   neutral-lightest: rgb("#ffffff"),
///   primary: rgb("#003F88"),
/// )
/// ```
///
/// - aspect-ratio (string): The aspect ratio of the slides. Default is `16-9`.
///
/// - navigation (string, none): The navigation of the slides. You can choose from `"sidebar"`, `"mini-slides"`, and `none`. Default is `none`.
///
/// - sidebar (dictionary): The configuration of the sidebar navigation.
///
/// - mini-slides (dictionary): The configuration of the mini-slides navigation.
///
/// - footer (content, function): The footer of the slides. Default is `none`.
///
/// - footer-right (content, function): The right part of the footer. Default is the page counter.
///
/// - primary (color): The primary color of the slides. Default is ZJU blue `rgb("#003F88")`.
///
/// - alpha (fraction, float): The alpha of transparency. Default is `40%`.
///
/// - subslide-preamble (content, function): The preamble of the subslide. Default is `none`.
#let zju-theme(
  aspect-ratio: "16-9",
  navigation: none,
  font: "Heiti SC",
  sidebar: (
    width: 10em,
    filled: false,
    numbered: false,
    indent: .5em,
    short-heading: true,
  ),
  mini-slides: (
    height: 4em,
    x: 2em,
    display-section: false,
    display-subsection: true,
    linebreaks: false,
    short-heading: true,
  ),
  footer: none,
  footer-right: context utils.slide-counter.display() + " / " + utils.last-slide-number,
  primary: zju-blue,
  alpha: 40%,
  subslide-preamble: none,
  ..args,
  body,
) = {
  sidebar = utils.merge-dicts(
    (width: 10em, filled: false, numbered: false, indent: .5em, short-heading: true),
    sidebar,
  )
  mini-slides = utils.merge-dicts(
    (height: 4em, x: 2em, display-section: false, display-subsection: true, linebreaks: true, short-heading: true),
    mini-slides,
  )
  set text(size: 16pt)
  set par(justify: true, leading: 1.25em)

  set cite(style: "chicago-notes")
  show footnote.entry: set text(.8em)

  show: touying-slides.with(
    config-page(paper: "presentation-" + aspect-ratio, header-ascent: 1.5em, footer-descent: 0em, margin: if navigation
      == "sidebar" {
      (top: 2em, bottom: 1em, x: sidebar.width)
    } else if navigation == "mini-slides" {
      (top: if mini-slides.linebreaks { mini-slides.height } else { 6em }, bottom: 3em, x: mini-slides.x)
    } else {
      (top: 5em, bottom: 2em, x: mini-slides.x)
    }),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(font: font)
        show heading: set text(self.colors.primary)
        show outline.entry: set block(above: 1em)

        body
      },
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      neutral-darkest: rgb("#000000"),
      neutral-dark: rgb("#202020"),
      neutral-light: rgb("#f3f3f3"),
      neutral-lightest: rgb("#ffffff"),
      primary: primary,
    ),
    // save the variables for later use
    config-store(
      navigation: navigation,
      sidebar: sidebar,
      mini-slides: mini-slides,
      footer: footer,
      footer-right: footer-right,
      alpha: alpha,
      subslide-preamble: subslide-preamble,
    ),
    ..args,
  )

  body
}
