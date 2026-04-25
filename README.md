<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E6%A0%A1%E5%BE%BD%E6%A0%A1%E5%90%8D%E7%BB%84%E5%90%88.svg" alt="校徽校名组合" />
</p>

<h1 align="center">北京邮电大学本科毕业设计论文 typst 模板</h1>

<p align="center">
  <a href="https://github.com/typst/typst"><img src="https://img.shields.io/badge/typst-template-239DAD.svg" alt="Typst"></a>
  <a href="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/main/LICENSE"><img src="https://img.shields.io/github/license/WongWang/typst-BUPT-Bachelor-Thesis" alt="LICENSE"></a>
  <a href=""><img src="https://img.shields.io/badge/format_check-passed-brightgreen.svg" alt="Format Check"></a>
</p>

这是依据北京邮电大学 2026 年本科毕业设计论文 Word 模板中的排版要求，使用 [typst](https://github.com/typst/typst) 编写的北邮本科毕业设计论文模板。

在模板中，我尽最大努力还原了官方 Word 模板中的行间距、缩进、页边距、图、表、公式等所有我能想得到（以及 Word 模板中提到）的东西的样式。

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E5%B0%81%E9%9D%A2%E5%AF%B9%E6%AF%94.png" alt="封面对比" />
</p>

可以看到最终的效果十分~~甚至九分~~的相似。

## 快速开始

### 1. 安装 typst

安装方式可参考 typst 官方仓库：

[https://github.com/typst/typst](https://github.com/typst/typst)

### 2. 获取模板

安装 typst 后，直接 clone 这个仓库的 main 分支即可。

```bash
git clone https://github.com/WongWang/typst-BUPT-Bachelor-Thesis.git
cd typst-BUPT-Bachelor-Thesis
```
> 如果不熟悉 Git 的话，直接右上角下载 zip 也行。

clone 下来的内容只有 README.md 是多余的。为了最小化 clone 的内容，这个 README 的所有图片均保存在 images 分支。

### 3. 编译 PDF

在项目目录下执行：

```bash
typst compile main.typ
```

即可编译生成 PDF。

每次编辑文本后需要重新编译才能在 main.pdf 看到效果。由于 typst 编译一次需要的时间通常是毫秒级的（不像 LaTeX 编译起步就要好几秒），所以有些编辑器也支持实时预览（也就是检测到修改之后立刻自动编译渲染）。

## 模板 Features

| Feature | 介绍 |
| --- | --- |
| 章节自动编号 | 自动将一级、二级、三级标题渲染成模板规定的格式 |
| 图、表、公式自动编号/引用 | 插入、移动、删除图表后，编号和正文引用会自动更新 |
| 参考文献自动编号/引用 | 使用 BibTeX 管理参考文献，按正文引用顺序自动编号并生成参考文献页 |
| 缩略语自动处理 | 自动判断缩略语是否首次出现，并生成缩略语表 |
| 自动生成超链接 | 图表、公式、参考文献等引用在 PDF 中均自动生成带定位的超链接 |
| 版本控制 | typst 文件为纯文本格式，能使用 Git 管理论文版本 |

## 为什么使用 typst 而非 Word 排版毕业论文

简而言之是因为 typst 能够做到内容与格式分离，用 typst 写论文的时候我可以专注于内容，而非一直跟格式较劲。~~另一个原因是那个官方 Word 模板太抽象了看不下去~~（虽然新版好了很多）。

> 没有用 LaTeX 只是因为 LaTeX 编译太慢，反复调各种距离太浪费时间。至于 LaTeX 的磅和 Word/typst 的磅大小不一样反而不是问题，因为虽然 typst 和 Word 的磅一样大，但 Word 的行距和 typst 的 leading 计算方法还是不一样，也就是说 Word 的 20 磅行距不等于 typst 的 leading: 20pt，最后还是得手动测量。

### 内容与格式分离

typst 这类排版工具相比 Word 最大的优点在于格式与内容分离。

如果你熟悉 LaTeX，那么快速扫一眼这部分，熟悉一下 typst 语法就行，因为 typst 的主要逻辑跟 LaTeX 没多大区别。

在使用这些工具写文档时，我们一般是先在一个文件（假设叫文件 A）中规定页边距该有多大，页眉、页脚长什么样，一级标题二级标题应该用什么字体怎么缩进，图/表前后间距该有多少之类的格式要求。

在格式编写完成之后，我们只需要在另一个文件 B 里面用一行代码 `include` 之前的格式文件 A，就可以不用再管哪里该缩进，哪里该加粗之类的细节了。只要我们在文件 B 里面告诉排版工具哪里是一级标题、哪里是公式，排版工具就会在编译时自动把一级标题按照我们文件 A 里指定好的一级标题格式渲染，公式按制定好的公式格式渲染，最终输出为完全符合文件 A 规定的格式的 PDF 文件。

### 章节自动编号

得益于这种“编译时才进行渲染”的特性，typst 这类工具可以实现非常灵活的自动编号。

例如以下是一段 typst 的正文代码（也就是上面说的文件 B）：

```typst
// main.typ

...

= 绪论

这是基于什么什么的研究，文本文本文本文本文本文本文本文本文本文本文本文本文本。

== 研究现状

文本文本文本文本文本文本文本文本文本。

== 当前研究存在的局限

文本文本文本文本文本文本。

= 研究方法

文本文本文本文本文本文本。

...
```

代码中一个 `=` 代表一级标题，两个则代表二级标题，以此类推。

当 typst 看到这段代码，它会从前往后数，记录当前遇到的是第几个一级/二级/三级标题，从而自动将 `= 绪论` 按照模板中指定好的格式居中渲染成 “第一章 绪论”，将 `== 当前研究存在的局限` 渲染成中文宋体，西文 Times New Roman 的“1.2 当前研究存在的局限”并自动在段前段后留出规定好的距离。

当然，章节自动编号，然后自动生成目录这点事 Word 也能干（虽然在临近 ddl 的时候因为在论文里新插入了一节，导致章节编号全部乱掉会让人迅速红温）。

typst 这类工具真正的优势在于***所有***要编号的地方全都可以自动完成，从页码到图/表/公式的引用，再到参考文献引用全都不用自己记录编号。

### 图、表、公式引用

举例来说，假如我们插入了一张图片，在 typst 里面，我们只要写：

```typst
// main.typ

...

== 标题

正文文字正文文字正文文字正文文字正文文字。如@fig:logo-img[]所示，正文文字正文文字正文文字正文文正文文字正文文字正文文字正文文字正文文字正文文字@feng2022vgg16[]。

#figure(
  box(stroke: 0.5pt, image("images/BUPT_logo_image.pdf")),
  caption: [图名],
) <fig:logo-img>

...
```

渲染出来的效果是这样：

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/2-1%E5%AF%B9%E6%AF%94.png" alt="图片引用效果" />
</p>

可以看到，我们用 `#figure()` 插入了一张图片，在 `caption` 输入了图名，然后在 `<>` 内指定了图的标签。

之后每当我们在正文想提到这张图（比如想说“...如图 2-1 所示...”），我们只要 `@` 一下这个标签就行。

至于那个标签对应的是图，是表还是公式，具体编号是几-几，我们在写正文的时候完全不用管，typst 在编译的时候全部会按照模板自动处理好。同时，这样生成的 PDF 中，每个引用都是带定位的超链接，只要点一下“图 2-1”，显示器上的画面就会跳到这张图所在的那页去。如果需要在正文中引用一张好几页之前/之后的图，那么这种功能将为论文潜在的读者提供不少便利。

> 这种图表自动编号的功能在 Word 里倒是也有，应该是叫“题注”。但是和 Word 的自动目录比，会用题注功能的人应该要少得多（而且它也不那么好用），可能有不少人论文里的图表编号都是手打上去的。

想象一下，假如你的导师看完你刚改的论文之后建议你把附录里的某张图移到第二章中间去，如果所有图表编号都是手敲的，那么你在把图片连同标题剪切到所需位置之后应该要：

1. 数一下这张图之前第二章有几张图，比如有 $x$ 章，那么需要把这张图的编号换成“图 2-<span>$(x+1)$</span>”。
2. 把这章后面每一张图的序号都往大加 1（比如“图 2-5”改为“图 2-6”）。
3. 搜索一下全文，找到所有引用这章后面任何一张图的地方，把所有引用的序号也全都加 1（比如“...如图 2-5 所示...”改为“...如图 2-6 所示...”）。
4. 把附录移走的图后面每一张图的序号都往前减 1。

这其中任何一个地方打错都会导致***引用错图片***或者***出现两个相同编号的图片***之类的问题。

如果经常进行这种修改，那么难免会出现错误。比如新版 Word 模板的续表就出现在了同一页内，大概是在前一页加了什么东西之后忘了删掉续表的表头：

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E7%BB%AD%E8%A1%A8.png" alt="续表" />
</p>

因此，如果你还在手打图表编号和引用，那么强烈建议你换到 typst 试试。

### 参考文献引用

实际上用 typst 写论文最方便的地方是参考文献引用。

在上面的那段代码里，我们引用了参考文献 `@feng2022vgg16[]`，这篇文献的详细数据是在 `reference.bib` 里面写好的：

```bibtex
// reference.bib

...

@article{feng2022vgg16,
  author    = {封晨 and 纪腾飞 and 杨琳},
  title     = {基于VGG16卷积神经网络的5G高噪调制识别技术},
  journal   = {中国新技术新产品},
  year      = {2022},
  number    = {13},
  pages     = {45--48}
}

...
```

这样的参考文献格式叫 BibTeX，无论你的参考文献是从哪里下载的，在下载按钮附近一定能找到 cite 或者 export BibTeX citation 之类的按钮，只要点一下就可以一键复制上面这种格式的参考文献数据。

只要把复制的 BibTeX 粘贴到 reference.bib 里，然后起个合适的名字（比如这里的 `feng2022vgg16`），回到正文就能直接用 `@` 引用。编译的时候 typst 会按所有参考文献引用***在正文中出现的顺序***自动对所有用到的参考文献编号，并放到论文结尾的参考文献页。

因此，如果我们想换一下两个参考文献的顺序，只需要重新 `@` 就行。想删掉不用的参考文献的话，只删掉对应的 `@` 就行，连 bib 文件都不用改（bib 文件里的参考文献只要没在正文里被 `@` 就不会被放进参考文献页）。

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E5%8F%82%E8%80%83%E6%96%87%E7%8C%AE.png" alt="参考文献效果" />
</p>

如你所见，只要简单地复制粘贴，然后一个 `@`，所有用到的参考文献会按国标 GB-7714-2015 要求输出，完全不需要再担心格式和编号问题。

### 缩略语

同样可以自动化的还有缩略语。

由于格式规范中要求缩略语第一次出现时写全称，比如“大语言模型（Large Language Models, LLMs）”，之后出现写缩写“LLMs”，然后最后把所有用到的缩略语放进附录。所以如果用 Word 排版，我们不仅要记住缩写是不是第一次出现（并手动针对使用不同格式），还要在写附录的时候注意别漏掉出现过的缩略语。

而在 typst 中，我们只需要预先定义缩略语：

```typst
// reference.bib

...

acronyms: (
  "LLMs": ("Large Language Models", "大语言模型"),
  "CNN": ("Convolutional Neural Network", "卷积神经网络"),
  "DNN": ("Deep Neural Network", "深度神经网络"),
),

...
```

然后在正文中使用 `#acr("LLMs")` 等命令调用即可。typst 会自动按是否第一次出现将缩略语渲染为合适的形式。同时像参考文献一样，只有被调用过的缩略语才会出现在附录 1 的缩略语表中。

### 版本控制

另外一个优势是：由于 typst 的文章是纯文本格式的，所以可以使用 Git 进行版本控制。如果你熟悉 Git，这将大幅简化论文修改难度。

### 小结

总而言之，借用另一个著名排版工具 LaTeX 中的比喻，使用格式与内容分离的排版工具写作就像在铺好的铁轨上开火车，只要路（格式）铺好了，我们就可以全心投入于驾驶（内容创作）；相反，使用 Word 这种所见即所得的工具排版就像在沙漠开拉力赛，如果你水平很高当然也能一路不停开到终点，但多数人还是难免会在中途因陷进沙子而需要下车垫轮胎。

希望各位能借此模板摆脱格式拘束，专注于创造~~或许~~有价值的内容。

## Word 模板的问题

这就不多说了，放点图大家自己看吧。

### a. “居中”

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/Word%E6%A8%A1%E6%9D%BF%E5%B0%81%E9%9D%A2.png" alt="Word 模板封面" />
</p>

我开始还以为这个校名摆放有什么讲究，毕竟那一竖差不多正好在中线上，说不定官方规定这里是中线？然后一看[校名使用规范](https://vi.bupt.edu.cn/jcxt/xmgf.htm#anchor2)：

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E6%A0%A1%E5%90%8D%E8%A7%84%E8%8C%83.png" alt="校名规范" />
</p>

原来左右没有额外留白，左右边界就是字体边界，那这个图没居中无疑了。

### b. “保持清晰度和可读性”

Word 模板里的校名和校徽只看上面的对比图好像清晰度还可以，但这最终还得放大到 A4 纸的大小，而原图只要放大到实际尺寸就能看见明显模糊：

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/Word%E6%A8%A1%E6%9D%BF%E6%A0%A1%E5%90%8D-%E6%94%BE%E5%A4%A7.png" alt="校名放大" />
</p>

既然官方给出了矢量图，那么不如直接在这里用矢量图，另外模板中的校徽颜色跟规范中的标准色也不一样：

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/Word%E6%A8%A1%E6%9D%BF%E6%A0%A1%E5%BE%BD-%E6%94%BE%E5%A4%A7.png" alt="校徽放大" />
</p>

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E6%A0%A1%E5%BE%BD%E8%A7%84%E8%8C%83-%E6%A0%87%E5%87%86%E8%89%B2%E5%8F%8A%E8%89%B2%E9%98%B6.png" alt="校徽标准色" />
</p>

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E6%A0%A1%E5%BE%BD%E8%A7%84%E8%8C%83-%E7%A6%81%E6%AD%A2%E4%BD%BF%E7%94%A8%E5%BD%A2%E5%BC%8F.png" alt="校徽禁止使用形式" />
</p>

### c. [新版模板已修复] “新的一章在奇数页”

那么 Page 6 是奇数页还是偶数页呢？（并非个例，这 Word 模板的摘要和后面几章也是在偶数页开始的）

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E9%A1%B5%E6%95%B0%E9%97%AE%E9%A2%98.png" alt="页数问题" />
</p>

### d. [新版模板前两章已修复，但后面三章又成了黑体] “西文字体 Times New Roman”

这怎么西文成黑体了呢：

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E5%AD%97%E4%BD%93%E9%97%AE%E9%A2%98.png" alt="字体问题" />
</p>

### e. [新版模板部分修复，有些章节还是不一样] “错落有致”

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E9%AB%98%E4%BD%8E%E6%90%AD%E9%85%8D.png" alt="高低搭配" />
</p>

## 这个模板是如何做到与 Word 模板的格式尽量一致的

其实整个排版过程主打一个手动测量，由于 Word 对行距的算法没有公开，所以没有任何其他方式能准确地将 Word 中的行距换算到 typst/LaTeX，只能渲染成 PDF 之后用标尺手动测量。

我首先在 Windows 下使用 Microsoft 365 中的 Word 将官方模板导出为 PDF，然后在 Linux 下使用 Inkscape 测量每个元素的坐标（测量结果舍入至 0.01mm），然后手动校对每个元素的高度。

最终实现的效果可以参考这个，Word 模板是黑色字，typst 生成的 PDF 为紫色字。其中第一行是因为原始 Word 模板没打标题，所以书名号里面的部分没法对齐，主要看后面几行的效果：

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E6%8E%92%E7%89%88%E5%B7%AE%E5%BC%82.png" alt="排版对比" />
</p>

放大了看是这样：

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E6%8E%92%E7%89%88%E5%B7%AE%E5%BC%82-%E6%94%BE%E5%A4%A7.png" alt="排版对比-放大" />
</p>

有一些极小的误差在所难免，但经测试发现，在同一版本的 Word 里点 Save，然后格式选 PDF 保存出来的结果，和直接点 Save 下面的 Save as Adobe PDF 出来的结果都存在几毫米的误差。如果用不同版本的 Word 打开，由于 Word 的 MathType 的兼容性问题，误差可能还会更大。因此相比之下这个 typst 模板的误差应该是可以接受的。

## 与 Word 版本不一致的地方与格式检测结果

目前已知不一致的地方有：

| 差异 | 详情 |
| --- | --- |
| 连续引用编号 | 连续引用两篇文献时，Word 模板中使用的上标为 [1-2]。而当前 typst 模板使用的是国标 GB/T 7714-2015 的 csl 文件，它会将两篇连续文献的编号写为 [1,2]，只有当连续引用超过三篇，才会使用横线，例如 [1-3]。 |
| 页末换页位置 | typst 会使用权重机制，依照分页后的美观程度决定在何处断页，因此 typst 输出的 PDF 通常页末最后一行看起来不会离页码过近。而 Word 的机制类似“只要离页边距还够放进去一行就多在前一页放一行”，所以有时候最后一行会离页码很近。不过一般 typst 生产的效果与 Word 只会有少数几行差距。 |

此模板已通过学校提供的格式检测网站的检测，结果如下：

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E6%A0%BC%E5%BC%8F%E6%A3%80%E6%B5%8B%E7%BB%93%E6%9E%9C-%E5%B7%AE%E9%94%99%E7%8E%87%E8%A6%81%E6%B1%82.png" alt="格式检测结果-差错率要求" />
</p>

<p align="center">
  <img src="https://github.com/WongWang/typst-BUPT-Bachelor-Thesis/blob/images/%E6%A0%BC%E5%BC%8F%E6%A3%80%E6%B5%8B%E7%BB%93%E6%9E%9C.png" alt="格式检测结果" />
</p>

## 如果导师让提交 Word 版本怎么办

如果导师是要阅读或者批注的话，使用 Acrobat Pro 可以直接将 PDF 转为所有文字均可编辑的 Word，且通常格式不会有明显变化（但前提是不在这个转换出来的 Word 上进一步编辑，只是批注/阅读或者用于字数统计是没问题的，非要编辑文字的话如果出现换行或者换页可能会导致后面的图表等东西错位）。

> 毕竟 PDF 是“电子的纸”，它可以保证无论在什么设备上打开，显示的内容都是一样的（显然 Word 做不到），因此即便论文是用 Word 写的，最后提交要打印的时候多半还是要转成 PDF（否则打印效果完全取决于打印店的 Word 版本，各种公式排版可能会出现问题）。

~~据当前能获取到的信息，检查格式是否合规的网站可以接受 PDF 版本的论文~~（已经确认格式检测网站可接受 PDF 格式），最后上传系统的时候多半也是要传 PDF 版本，所以我们直接渲染出 PDF 应该不会有任何问题。

## 模板存在的错误与未来版本

我已经尽量校对确保当前模板与 Word 模板一致，如果你发现当前模板存在的任何问题，或者在使用方面存在困惑，欢迎发 Issue，我在看到后将尽快修复问题。

另外由于毕业后应该没办法再获取到最新的毕业论文 Word 模板，所以如果未来论文格式要求出现较大变化，欢迎将新的 Word 模板发到 Issue，如果有时间的话我会根据新的 Word 模板继续更新当前模板。

另外如果你愿意直接对当前模板进行修改，也可以在修改完成后连同新的 Word 模板一起发 Pull Request。

感谢各位为未来的校友们做出贡献，在这里祝大家答辩顺利通过。
