// template.typ — 北京邮电大学本科毕业设计模板
// 基于“附件5：北京邮电大学2026届本科毕业设计（论文）模板+（更新）.docx”的格式要求

// =========================================================
// 1. 辅助工具
// =========================================================
// ========== 脚注符号（圆圈内数字）转换 ==========
#let circled(n) = {
  if n <= 20 {
    str.from-unicode(0x2460 + n - 1)
  } else if n <= 35 {
    str.from-unicode(0x3251 + n - 21)
  } else if n <= 50 {
    str.from-unicode(0x32B1 + n - 36)
  } else {
    // 超过 50 回退为 (n) 的形式
    super(str(n))
  }
}

// ========== 伪粗体 ==========
#import "@preview/cuti:0.4.0": show-cn-fakebold, fakebold
#show: show-cn-fakebold

// ========== 字号转换 ==========
#let chuhao = 42pt
#let xiaochu = 36pt
#let yihao = 26pt
#let xiaoyi = 24pt
#let erhao = 22pt
#let xiaoer = 18pt
#let sanhao = 16pt
#let xiaosan = 15pt
#let sihao = 14pt
#let xiaosi = 12pt
#let wuhao = 10.5pt
#let xiaowu = 9pt
#let liuhao = 7.5pt
#let xiaoliu = 6.5pt
#let qihao = 5.5pt
#let bahao = 5pt

// ========== State 状态 ==========
// 缩略语标记
#let _all-acronyms = state("all-acronyms", (:))
#let _used-acronyms = state("used-acronyms", ())

// 标记当前是否处于附录内（附录标题在目录中需要少一个空格，在实际附录需要多一个空格）
#let _in-appendix = state("in-appendix", false)

#let acr(key) = context {
  let all = _all-acronyms.get()
  if key not in all {
    key
  } else {
    let used = _used-acronyms.get()
    let (en, cn) = all.at(key)
    if key in used {
      key
    } else {
      _used-acronyms.update(u => u + (key,))
      cn + "（" + en + ", " + key + "）"
    }
  }
}

// ========== 中文数字转换 ==========
#let chinese-numbering(..nums) = {
  let map = ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十")
  let n = nums.pos().first()
  if n < 11 {
    map.at(n)
  } else if n < 20 {
    "十" + if calc.rem(n, 10) != 0 { map.at(calc.rem(n, 10)) }
  } else if n < 100 {
    map.at(int(n / 10)) + "十" + if calc.rem(n, 10) != 0 { map.at(calc.rem(n, 10)) }
  } else {
    str(n)
  }
}

// ========== 三线表 ==========
// 三线表（如果跨页则自动分页，续页显示"续表 X-Y 标题"并重复表头）
#let three-line-table(caption: none, label: none, note: none, header: (), ..args) = {
  // 计算列数
  let cols = args.named().at("columns", default: header.len())
  let n-cols = if type(cols) == int { cols } else { cols.len() }

  // 用状态区分首页/续页
  let is-first = state("cont-tbl-" + repr(label), true)

  let tbl = table(
    stroke: none,
    ..args.named(),

    // 表头（每页重复）
    table.header(
      // 续表标题行：首页隐藏，续页显示"续表 X-Y 标题"
      table.cell(colspan: n-cols, inset: 0pt)[
        #context {
          if is-first.get() {
            is-first.update(false)
          } else {
            block(inset: (top: 1.12mm, bottom: 2.38mm))[
              #set text(font: ("Times New Roman", "KaiTi"), size: wuhao)
              #let chap = counter(heading).get().first()
              #let num = counter(figure.where(kind: table)).get().first()
              续表 #str(chap)-#str(num) #caption
            ]
          }
        }
      ],
      table.hline(stroke: 1pt), // 顶部粗线
      ..header,
      table.hline(stroke: 0.5pt), // 表头下细线
    ),

    // 数据行
    ..args.pos(),

    // 表尾（每页重复）：底部粗线
    table.footer(
      repeat: true,
      table.hline(stroke: 1pt),
      // 如果表的最下方加上 1.8 mm 空白后超出下方 2.5 cm 的页边距限制，则触发表格分页
      table.cell(colspan: n-cols, inset: (bottom: 1.8mm))[],
    ),
  )

  let body = if note != none {
    grid(
      columns: 1,
      align: left,
      tbl,
      v(-2.26mm),
      text(size: xiaowu, font: ("Times New Roman", "NSimSun"))[注：#note],
      v(4.75mm), // 与无注释表对齐
    )
  } else {
    tbl
  }
  // 允许表格跨页
  show figure.where(kind: table): set block(breakable: true)
  let fig = figure(body, caption: caption, kind: table, supplement: [表])
  if label != none {
    [#fig#label]
  } else {
    fig
  }
}

// ========== 算法 ==========
#let algorithm(caption: none, label: none, body) = {
  let body-content = context {
    let chap = counter(heading).get().first()
    let num = counter(figure.where(kind: "algorithm")).get().first()
    block(width: 100%, table(
      columns: (1fr,),
      stroke: none,
      align: left,
      inset: (x: 2.05mm, y: 1mm),
      table.hline(stroke: 1pt),
      [
        #set par(first-line-indent: 0pt, justify: true)
        #set text(font: ("Times New Roman", "KaiTi"), size: wuhao)
        #v(2.81mm)
        算法 #str(chap)-#str(num)#h(1em)#caption
        #v(1.72mm)
      ],
      table.hline(stroke: 0.5pt),
      [
        #set par(first-line-indent: 0pt, justify: false, leading: 1.003em, spacing: 1.003em)
        #set text(font: ("Times New Roman", "DengXian"), size: wuhao)
        #v(0.13mm)
        #body
        #v(1.18mm)
      ],
      table.hline(stroke: 1pt),
      v(1.87mm)
    ))
  }

  let fig = figure(
    body-content,
    caption: caption,
    kind: "algorithm",
    supplement: [算法],
  )
  if label != none {
    [#fig#label]
  } else {
    fig
  }
}

// ========== 子图 ==========
#import "@preview/subpar:0.2.2"
// 将 subpar 包装为 subfigure（子图等高、子图标题楷体五号、引用格式 "图 2-2(a)"）
// sub-height: 子图图片高度（默认 4cm）
// sub-gutter: 子图之间的水平间距（默认 1em）
#let subfigure(sub-height: auto, sub-gutter: 1em, ..args) = {
  set figure(gap: 4.71mm) // 子图与子图名之间的距离
  align(center,
    subpar.grid(
      numbering: (..nums) => context {
        let chap = counter(heading).get().first()
        str(chap) + "-" + str(nums.pos().first())
      },
      numbering-sub: "(a)",
      numbering-sub-ref: (sup, sub) => context {
        let chap = counter(heading).get().first()
        str(chap) + "-" + str(sup) + "(" + numbering("a", sub) + ")"
      },
      show-sub-caption: (num, it) => {
        set text(font: ("Times New Roman", "KaiTi"), size: wuhao)
        num
        [ ]
        it.body
      },
      show-sub: it => {
        set image(height: sub-height)
        it
      },
      gap: 2.5mm, // 子图名与外层图名之间的距离
      gutter: sub-gutter,
      ..args,
    )
  )
}

// ========== 页眉格式 ==========
#let main-header = context {
  // 页眉文字顶部距离页面顶 15.6 mm
  place(top + center, dy: 15.6mm)[
    #set text(size: xiaowu, top-edge: "bounds")
    北京邮电大学本科毕业设计（论文）
  ]
  // 页眉线粗 0.72 pt
  let line-thickness = 0.72pt
  // 页眉线距离页面顶 19.45 mm
  place(top + center, dy: 19.45mm + (line-thickness / 2))[
    #line(length: 100%, stroke: line-thickness)
  ]
}

// ========== 页脚格式 ==========
#let main-footer = context place(top + center, dy: 5.95mm)[
  // 依据模板，页码使用宋体（不知道为什么这么规定，这全是数字又不用 Times New Roman 了）
  #set text(font: ("SimSun"), size: xiaowu, top-edge: "bounds")
  #counter(page).display("1")
]

// 罗马数字页脚
#let roman-footer = context place(top + center, dy: 5.95mm)[
  #set text(font: ("Times New Roman"), size: xiaowu, top-edge: "bounds")
  #counter(page).display("I")
]

// ========== Chapter 计数器 ==========
#let chapter-counter = counter("chapter")

// =========================================================
// 2. 论文模板
// =========================================================
#let project(
  title-cn: "",
  title-en: "",
  author: "",
  school: "",
  major: "",
  class: "",
  student-id: "",
  supervisor: "",
  date: (year: "2026", month: "6"),
  abstract-cn: [],
  keywords-cn: (),
  abstract-en: [],
  keywords-en: (),
  acknowledgements: [],
  acronyms: (:),
  achievements: none,
  appendix: none,
  bibliography-file: none,
  body,
) = {
  // 注册缩略语字典
  _all-acronyms.update(acronyms)

  // 全局页面设置，上下左右页边距 2.5 cm
  set document(title: title-cn, author: author)
  set page(
    paper: "a4",
    margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
    header-ascent: 0cm,
    footer-descent: 0cm,
  )

  // 正文字体：中文宋体，西文 Times New Roman，小四号(12pt)
  // 这里使用 NSimSun 因为标准的宋体 SimSun 存在 Fallback 问题，没匹配到 Times New Roman 就会退回到 Noto 而非宋体
  // NSimSun 的所有汉字与标准宋体完全相同，仅修改了字母和数字，但我们正好在正文里字母和数字都用 Times New Roman，所以没有影响
  set text(font: ("Times New Roman", "NSimSun"), size: 12pt, lang: "zh", region: "cn")
  // [上一版] Word 1.25 倍行距在小四号字下对应 leading 0.939em，spacing 设置为与 leading 相同对应段前段后 0 行，首行缩进 2 个字
  // 2026 年 4 月 22 日模板再次更新，正文行距变为 1.5 倍。经测量，对应行间距 1.2621em，段间距 1.2621em
  set par(leading: 1.2621em, first-line-indent: (amount: 2em, all: true), spacing: 1.2621em, justify: true)

  // 去掉脚注上方的分隔线
  set footnote.entry(separator: none)

  // 脚注符号样式（圆圈数字）
  show footnote: it => {
    // 正文区域的脚注上标
    let num = counter(footnote).at(it.location())
    super(circled(num.last()))
  }
  show footnote.entry: it => {
    // 脚注区域的脚注标
    let num = counter(footnote).at(it.note.location())
    block(inset: (bottom: 0.9mm))[#circled(num.last()) #it.note.body]
  }

  // 标题编号格式
  set heading(numbering: none)
  show heading: it => {
    set text(font: ("Times New Roman", "SimHei"))
    fakebold(it)
  }

  // 一级标题：三号，黑体，居中
  show heading.where(level: 1): it => {
    pagebreak(weak: true, to: "odd")
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: "algorithm")).update(0)
    counter(math.equation).update(0)
    set text(size: sanhao)
    set par(first-line-indent: 0pt)
    v(1.8mm)
    align(center, it)
    v(10.92mm)
  }

  // 二级标题：四号，黑体，左对齐
  show heading.where(level: 2): it => {
    context {
      set text(size: sihao)
      set par(first-line-indent: 0pt)
      v(1.44mm)
      let num-str = if it.numbering != none {
        text(font: "SimHei")[#counter(heading).display(it.numbering)]
      }
      let new-heading = if num-str != none {
        [#num-str #it.body]
      } else {
        it.body
      }
      set text(font: ("Times New Roman", "SimHei"))
      fakebold(new-heading)
      v(1.85mm)
    }
  }

  // 三级标题：小四，黑体，左对齐，首行缩进 2 字符
  show heading.where(level: 3): it => {
    set text(size: xiaosi)
    set par(first-line-indent: 0pt)
    v(2.10mm)
    box(inset: (left: 2em), it)
    v(2.14mm)
  }

  // 四级标题（不进入目录）：小四，宋体，左对齐，首行缩进 2 字符
  show heading.where(level: 4): it => {
    set par(first-line-indent: 0pt)
    v(2.11mm)
    let new-heading = context {
      let num-str = counter(heading).get()
      if it.numbering != none and num-str.len() > 0 {
        [#(num-str.last()). #it.body]
      } else {
        it.body
      }
    }
    set text(font: ("Times New Roman", "NSimSun"))
    box(inset: (left: 2em), fakebold(new-heading))
    v(2.11mm)
  }


  // 图默认引用前缀为"图"，表默认为"表"
  show figure.where(kind: image): set figure(supplement: [图])
  show figure.where(kind: table): set figure(supplement: [表])

  // 图表按章编号
  set figure(numbering: (..nums) => {
    context {
      let chap = counter(heading).get().first()
      str(chap) + "-" + str(nums.pos().first())
    }
  })

  // 公式按章编号
  set math.equation(
    numbering: (..nums) => context {
      let chap = counter(heading).get().first()
      set text(font: ("Times New Roman", "NSimSun"), size: xiaosi)
      "（" + str(chap) + "-" + str(nums.pos().first()) + "）"
    },
    supplement: [],
  )
  // 引用公式时去掉空的 supplement 和编号间的空格，避免在“式”前面多个空格
  // 引用图表时使用元素自身的 supplement（图/表），避免 @label[] 传入空 supplement
  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation {
      link(el.location(), numbering(el.numbering, ..counter(math.equation).at(el.location())))
    } else if el != none and el.func() == figure {
      let nums = counter(figure.where(kind: el.kind)).at(el.location())
      let num-str = numbering(el.numbering, ..nums)
      link(el.location(), [#el.supplement #num-str])
    } else {
      it
    }
  }
  // 公式格式
  // 单个公式：上 1.94 mm，下 -6.45 mm。
  // 如果后面紧接另一块级元素（公式、图、表等），则取消 -6.45 mm 以防重叠。
  show math.equation.where(block: true): it => context {
    let loc = it.location()
    let followups = query(selector.or(
      math.equation.where(block: true),
      figure,
    ).after(loc))
    let has-close-followup = followups.any(fo => (
      fo.location() != loc
      and fo.location().page() == loc.page()
      and (fo.location().position().y - loc.position().y) < 2cm
    ))
    v(1.94mm)
    it
    if not has-close-followup {
      v(-6.45mm)
    }
  }

  // 图表标题（楷体，五号）
  show figure.caption: it => {
    set text(font: ("Times New Roman", "KaiTi"), size: wuhao)
    it
  }
  // 图标题与图之间的间距（标题上方距离图的距离）
  set figure(gap: 4.87mm)
  // 表标题与表之间的间距（标题下方距离表的距离）
  show figure.where(kind: table): set figure(gap: 4.58mm)

  show figure: it => {
    let is-table = it.kind == table
    let is-algorithm = it.kind == "algorithm"
    if is-algorithm {
      // 算法已经把"算法 X-Y 标题"画进三线表里，所以直接渲染 it.body
      context {
        let y = here().position().y
        if y > 2.5cm + 0.5mm {
          v(1.9mm)
        }
      }
      block(below: 1.8mm, it.body)
    } else {
      context {
        // 图和表在页顶取消上边距
        // 判断是否在页顶
        let y = here().position().y
        if y > 2.5cm + 0.5mm {
          v(if is-table { 1.9mm } else { 0.7mm }) // 表的标题上方边距更大
        }
      }
      if is-table {
        block(below: 1.8mm, it) // 表需要去掉 figure 后面的默认空隙，完全手动控制间距（因为表可能有"注"这部分）
      } else {
        it
        v(1.8mm)
      }
    }
  }

  // 表格格式
  set table(
    stroke: none,
    inset: 6pt,
  )
  show table: set text(size: wuhao)
  show figure.where(kind: table): set figure.caption(position: top)

  // ==================== 封面 ====================
  {
    set page(header: none, footer: none, numbering: none)
    set par(leading: 0.25em, first-line-indent: 0pt, spacing: 0.25em)
    
    // 校名
    v(0.04mm)
    figure(
      image("logo/BUPT_name.pdf")
    )

    // 本科毕业设计（论文）
    v(12.11mm)
    align(center, text(font: ("Times New Roman", "SimHei"), size: yihao)[
      #fakebold[本#h(0.5em)科#h(0.5em)毕#h(0.5em)业#h(0.5em)设#h(0.5em)计（ 论#h(0.5em)文 ）]
    ])

    // 校徽
    v(11.51mm)
    figure(
      image("logo/BUPT_logo.pdf")
    )

    // 题目（下划线宽 102mm，单行一条线，超宽自动两行两条线）
    v(10.5mm)
    {
      let line-length = 102mm
      let line-offset = 3.5pt  // 下划线在文字基线下方 3.5pt
      set text(font: "SimHei", size: sanhao)
      set par(leading: 0.75em)
      context {
        let title-body = fakebold[#title-cn]
        let title-w = measure(title-body).width
        let two-lines = title-w > line-length
        let content-h = measure(box(width: line-length, align(center, title-body))).height
        // 测量加粗的“题”的高度作为单行高度
        let single-h = measure(box(width: line-length, align(center, fakebold[题]))).height

        align(center)[
          #fakebold[题目：]#box(width: line-length, baseline: content-h - single-h)[
            // 题目文字居中（自然撑开高度，baseline 自动对齐）
            #align(center)[#title-body]
            // 最后一行文字下方的下划线
            // 单行时在 content-h 处，两行时也在 content-h 处（即最后一行下方）
            #place(left + top, dy: content-h + line-offset)[
              #line(length: line-length, stroke: 0.5pt)
            ]
            // 标题需要两行时第一行的下划线
            #if two-lines {
              let first-line-h = single-h
              place(left + top, dy: first-line-h + line-offset)[
                #line(length: line-length, stroke: 0.5pt)
              ]
            }
          ]
        ]
      }
    }

    // 信息表
    v(16.69mm)
    {
      let lw = 4em        // 标签列宽

      // 计算值的列宽
      let all-values = (author, school, major, class, student-id, supervisor)
      let min-limit = 10  // 最窄 10 em
      let max-limit = 15  // 最宽 15 em
      let max-len = calc.max(..all-values.map(v => v.clusters().len()))  // 计算最长的值的字符数
      // 如果最长的值的字符数 + 1 之后位于 min-limit 和 max-limit 之间，则使用该值作为列宽，
      // 否则使用 min-limit 或 max-limit
      let vw = calc.max(calc.min(max-len + 1, max-limit), min-limit) * 1em

      set text(size: sanhao)
      // 均匀撑满标签列宽
      let make-label(s) = {
        let chars = s.clusters()
        box(width: lw, text[#fakebold[#chars.join(h(1fr))]])
      }
      let info-row(label, value) = (
        make-label(label),
        box(width: vw)[
          #align(center)[#fakebold[#value]]
          #line(length: 100%, stroke: 0.5pt)
        ],
      )
      align(center,
        grid(
          columns: (lw, vw),
          column-gutter: 0.2cm,
          row-gutter: 5.72mm,
          align: (left, left),
          ..info-row("姓名", author),
          ..info-row("学院", school),
          ..info-row("专业", major),
          ..info-row("班级", class),
          ..info-row("学号", student-id),
          ..info-row("指导教师", supervisor),
        )
      )
    }

    // 日期
    v(15.99mm)
    align(center, text(size: sanhao)[
      #fakebold[#date.year #h(0.5em) 年 #h(0.5em) #date.month #h(0.5em) 月]
    ])
    pagebreak()
  }

  // ==================== 诚信声明 ====================
  {
    set page(header: none, footer: none, numbering: none)
    set par(leading: 0.25em, first-line-indent: 0pt, spacing: 0.25em)

    v(12mm)
    align(center, text(size: xiaosan)[
      #fakebold[北#h(0.5em)京#h(0.5em)邮#h(0.5em)电#h(0.5em)大#h(0.5em)学]
    ])
    v(5.36mm)
    align(center, text(size: xiaosan)[
      #fakebold[本科毕业设计（论文）诚信声明]
    ])

    v(1.03mm)
    set par(first-line-indent: 2em, leading: 1.26em, spacing: 1.26em)
    set text(size: xiaosi)

    [本人声明所呈交的毕业设计（论文），题目《#title-cn》是本人在指导教师的指导下，独立进行研究工作所取得的成果。尽我所知，除了文中特别加以标注和致谢中所罗列的内容以外，论文中不包含其他人已经发表或撰写过的研究成果，也不包含为获得北京邮电大学或其他教育机构的学位或证书而使用过的材料。
    
    申请学位论文与资料若有不实之处，本人承担一切相关责任。]

    v(7.32mm)
    [ #h(0.02mm) 本人签名：#box(
      width: 42.34mm, 
      outset: (bottom: 2pt), 
      stroke: (bottom: 0.5pt)
    ) #h(9.52mm) 日期：#box(
      width: 48.69mm, 
      outset: (bottom: 2pt), 
      stroke: (bottom: 0.5pt)
    )]

    v(28.23mm)
    align(center, text(size: xiaosan)[
      #fakebold[关于论文使用授权的说明]
    ])

    v(-0.34mm)
    // 学校 2026 年的 Word 模板这里还打错个符号，原版是“...复制手段保存。汇编学位论文...”，这里已经将错误的句号改为顿号
    [本人完全了解并同意北京邮电大学有关保留、使用学位论文的规定，即：北京邮电大学拥有以下关于学位论文的无偿使用权，具体包括：学校有权保留并向国家有关部门或机构送交学位论文，有权允许学位论文被查阅和借阅；学校可以公布学位论文的全部或部分内容，有权允许采用影印、缩印或其它复制手段保存、汇编学位论文，将学位论文的全部或部分内容编入有关数据库进行检索。（保密的学位论文在解密后遵守此规定）]

    v(7.35mm)
    [ #h(0.02mm) 本人签名：#box(
      width: 42.34mm, 
      outset: (bottom: 2pt), 
      stroke: (bottom: 0.5pt)
    ) #h(9.52mm) 日期：#box(
      width: 48.69mm, 
      outset: (bottom: 2pt), 
      stroke: (bottom: 0.5pt)
    )]
    v(7.32mm)
    [ #h(0.02mm) 导师签名：#box(
      width: 42.34mm, 
      outset: (bottom: 2pt), 
      stroke: (bottom: 0.5pt)
    ) #h(9.52mm) 日期：#box(
      width: 48.69mm, 
      outset: (bottom: 2pt), 
      stroke: (bottom: 0.5pt)
    )]

    pagebreak()
  }

  // ==================== 中文摘要 ====================
  {
    set page(
      header: none,
      footer: roman-footer,
      numbering: "I",
    )
    counter(page).update(1)
    pagebreak(weak: true, to: "odd") // 从奇数页开始

    v(6.11mm)
    {
      set par(first-line-indent: 0pt)
      // 保留 Times New Roman 和 weight: bold 以防标题中有英文部分
      align(center, text(font: ("Times New Roman", "SimHei"), size: sanhao, weight: "bold")[#fakebold[#title-cn]])
    }

    v(16.5mm)
    {
      set par(first-line-indent: 0pt)
      align(center, text(font: ("Times New Roman", "SimHei"), size: xiaosan)[#fakebold[摘要]])
    }

    v(6.96mm)
    abstract-cn

    v(8.21mm)
    {
      set par(first-line-indent: 2em)
      text(font: ("Times New Roman", "SimHei"))[#fakebold[关键词]]
      h(0.5em)
      keywords-cn.join(h(1em))
    }
    pagebreak()
  }

  // ==================== 英文摘要 ====================
  {
    set page(
      header: none,
      footer: roman-footer,
    )
    pagebreak(weak: true, to: "odd") // 从奇数页开始

    v(1.53mm)
    {
      set par(first-line-indent: 0pt)
      align(center, text(font: ("Times New Roman"), size: sanhao, weight: "bold")[#title-en])
    }

    v(15.48mm)
    {
      set par(first-line-indent: 0pt)
      align(center, text(font: "Times New Roman", size: xiaosan, weight: "bold")[ABSTRACT])
    }

    v(6.9mm)
    {
      // 纯英文段落字体不一样，因此行距不同
      set par(leading: 1.062em, spacing: 1.062em)
      abstract-en
    }

    v(6.52mm)
    {
      set par(first-line-indent: 2em)
      text(font: "Times New Roman", weight: "bold")[KEY WORDS]
      h(1em)
      keywords-en.join(h(1em))
    }
    pagebreak()
  }

  // ==================== 目录 ====================
  {
    set page(
      header: none,
      footer: roman-footer,
    )
    pagebreak(weak: true, to: "odd") // 从奇数页开始

    v(1.8mm)
    {
      set par(first-line-indent: 0pt)
      align(center, text(font: ("SimHei"), size: sanhao)[#fakebold[目录]])
    }

    v(22.18mm)
    set par(first-line-indent: 0pt, leading: 4.16mm, spacing: 4.16mm)
    set text(font: ("Times New Roman", "NSimSun"), size: xiaosi)
    set outline.entry(fill: repeat(gap: 0.05em)[.]) // 调整引导线点密度

    // 一级标题：黑体，不加粗，段前间距
    // 附录条目重建前缀（去掉 numbering 函数中的 h(0.5em)，仅保留默认间距）
    show outline.entry.where(level: 1): it => {
      set text(font: ("Times New Roman", "SimHei"))
      let el = it.element
      let in-app = _in-appendix.at(el.location())
      let prefix = if in-app and el.numbering != none {
        let n = counter(heading).at(el.location()).first()
        [附录#n]
      } else {
        it.prefix()
      }
      link(el.location(), it.indented(prefix, it.inner()))
    }
    // 二三级标题：宋体，不加粗（由全局 set text 设置）

    // indent 函数：level 从 0 开始，一级 2em，二级 3em，三级 4em
    outline(title: none, indent: n => n * 2em, depth: 3)
    pagebreak(to: "odd") // 确保正文从奇数页开始，空白页保留目录的页面样式
  }

  // ==================== 正文 ====================
  {
    set page(
      header: main-header,
      footer: main-footer,
      numbering: "1",
    )
    counter(page).update(1)

    // 章节编号
    set heading(numbering: (..nums) => {
      let n = nums.pos()
      if n.len() == 1 {
        "第" + chinese-numbering(n.first()) + "章"
      } else {
        n.map(str).join(".")
      }
    })

    // 使正文宋体支持使用“**”进行加粗
    show strong: show-cn-fakebold

    body
  }

  // ==================== 参考文献 ==================== 
  if bibliography-file != none {
    set page(
      header: main-header,
      footer: main-footer,
    )

    pagebreak(weak: true)
    heading(level: 1, numbering: none)[参考文献]

    set text(size: wuhao)
    set par(first-line-indent: 0pt)
    bibliography(bibliography-file, title: none, style: "gb-7714-2015-numeric")
  }

  // ==================== 致谢 ==================== 
  if acknowledgements != [] {
    set page(
      header: main-header,
      footer: main-footer,
    )
    pagebreak(weak: true)
    heading(level: 1, numbering: none)[致谢]
    acknowledgements
  }

  // ==================== 附录 ==================== 
  if appendix != none or _used-acronyms.final().len() > 0 {
    set page(
      header: main-header,
      footer: main-footer,
    )

    // 进入附录标记
    _in-appendix.update(true)

    // 每个附录作为独立一级标题（像每章一样），编号为"附录N"
    counter(heading).update(0)
    set heading(numbering: (..nums) => {
      let n = nums.pos()
      if n.len() == 1 {
        "附录" + str(n.first())
        h(0.5em)
      } else {
        n.map(str).join(".")
      }
    })

    // 附录中的图/表/公式单独编号：附 N-1、式（附 N-1）
    set figure(numbering: (..nums) => context {
      let n = counter(heading).get().first()
      "附" + str(n) + "-" + str(nums.pos().first())
    })
    set math.equation(numbering: (..nums) => context {
      let n = counter(heading).get().first()
      set text(font: ("Times New Roman", "NSimSun"), size: xiaosi)
      "式（附" + str(n) + "-" + str(nums.pos().first()) + "）"
    })

    // 附录中只有一级标题进目录
    show heading.where(level: 2): set heading(outlined: false)
    show heading.where(level: 3): set heading(outlined: false)
    show heading.where(level: 4): set heading(outlined: false)
    show heading.where(level: 5): set heading(outlined: false)

    // 如果全文使用了缩略语，自动插入附录 1 缩略语表
    context {
      let used = _used-acronyms.final().dedup().sorted()
      if used.len() > 0 {
        let all = _all-acronyms.get()
        heading(level: 1)[缩略语表]
        table(
          columns: (auto, 1fr),
          stroke: none,
          inset: (y: 2.8mm),
          align: (left + horizon, left + horizon),
          ..used.map(key => {
            let (en, cn) = all.at(key)
            (key, en + "，" + cn)
          }).flatten(),
        )
      }
    }

    if appendix != none {
      appendix
    }
  }

  // ==================== 攻读学位期间取得的创新成果 ==================== 
  if achievements != none {
    set page(
      header: main-header,
      footer: main-footer,
    )
    pagebreak(weak: true)
    heading(level: 1, numbering: none)[攻读学位期间取得的创新成果]

    // 子标题：黑体、正文字号、首行不缩进、不进目录
    let ach-title(title) = {
      set par(first-line-indent: 0pt)
      text(font: ("Times New Roman", "SimHei"), size: xiaosi)[#fakebold[#title]]
      parbreak()
    }
    // 条目列表：[1][2]... 编号，正文字号，每段重置从 1 开始
    let ach-list(items) = {
      set par(first-line-indent: 0pt)
      set enum(numbering: "[1]", indent: 0pt)
      enum(..items.map(i => [#i]))
    }

    let papers = achievements.at("papers", default: ())
    let patents = achievements.at("patents", default: ())
    let competitions = achievements.at("competitions", default: ())

    if papers.len() > 0 {
      ach-title[论文]
      ach-list(papers)
    }
    if patents.len() > 0 {
      ach-title[专利]
      ach-list(patents)
    }
    if competitions.len() > 0 {
      ach-title[竞赛]
      ach-list(competitions)
    }
  }
}
