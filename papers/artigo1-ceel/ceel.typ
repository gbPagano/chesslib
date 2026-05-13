// ceel.typ
// Template Typst para artigos da XXIII CEEL, baseado nas normas oficiais.

#let ceel-authors(authors) = {
    let card(author) = block[
        #set par(first-line-indent: 0pt, justify: false)
        #align(left)[
            #author.name \
            #author.department \
            #author.organization \
            #author.location \
            #author.orcid
        ]
    ]

    if authors.len() == 1 {
        card(authors.at(0))
    } else if authors.len() == 2 {
        grid(
            columns: (1fr, 1fr),
            gutter: 6mm,
            card(authors.at(0)),
            card(authors.at(1)),
        )
    } else {
        grid(
            columns: (1fr, 1fr, 1fr),
            gutter: 6mm,
            card(authors.at(0)),
            card(authors.at(1)),
            card(authors.at(2)),
        )
    }
}

#let ceel-title-block(
    title: "",
    authors: "",
    event: [CEEL - ISSN 2596-2221],
    institution: [Universidade Federal de Uberlândia],
    date: [18 a 21 de Maio de 2026],
    left-logo: "assets/logo_ceel.png",
    right-logo: "assets/ufu.png",
) = block(width: 100%)[
    #set par(first-line-indent: 0pt, justify: false)

    // Bloco delimitador exclusivo para o cabeçalho superior
    #block(width: 100%)[
        // Posicionamento absoluto ancorado na base do bloco
        #place(bottom + left)[
            #image(left-logo, width: 16mm)
        ]
        #place(bottom + right)[
            #image(right-logo, width: 15mm)
        ]

        // O texto flui normalmente e perfeitamente centralizado
        #align(center)[
            #text(size: 14pt, weight: "bold")[#event] \
            #text(size: 12pt, weight: "bold")[#institution] \
            #text(size: 11pt, weight: "bold")[#date]
        ]
    ]

    #v(1.0em)
    #align(center)[#text(size: 14pt, weight: "bold")[#upper(title)]]
    #v(1.05em)
    #ceel-authors(authors)
]

#let ceel-abstract(label, body) = [
    // Define o recuo da primeira linha e o alinhamento justificado
    #set par(first-line-indent: (amount: 4mm, all: true), justify: true)
    
    // Aplica negrito e itálico APENAS ao rótulo, separando do corpo
    #text(weight: "bold")[#emph(label) - #body]
]

#let ceel-keywords(label, words) = [
    #set par(first-line-indent: (amount: 4mm, all: true), justify: true)
    #text(weight: "bold")[#emph(label) - #words.join(", ")]
]

#let ceel-english-title(title) = [
    #set par(first-line-indent: 0pt, justify: false)
    #set align(center)
    #text(size: 12pt, weight: "bold")[#upper(title)]
]

#let ceel-unnumbered(title) = [
    #align(center)[#text(weight: "bold")[#upper(title)]]
]

#let ceel(
    title: "",
    authors: "",
    abstract: "",
    keywords: "",
    title-en: none,
    abstract-en: none,
    keywords-en: (),
    event: [CEEL - ISSN 2596-2221],
    institution: [Universidade Federal de Uberlândia],
    date: [18 a 21 de Maio de 2026],
    left-logo: "assets/logo_ceel.png",
    right-logo: "assets/ufu.png",
    body,
) = {
    set document(title: title)
    set page(
        paper: "a4",
        margin: (top: 25mm, bottom: 25mm, left: 18mm, right: 12mm),
        columns: 2,
        numbering: "1",
        number-align: bottom + center,
    )
    set columns(gutter: 6mm)
    set text(
        font: ("Times New Roman", "TeX Gyre Termes"),
        size: 10pt,
        lang: "pt",
        region: "BR",
    )
    set par(justify: true, first-line-indent: (amount: 4mm, all: true), leading: 0.52em)
    
    set heading(numbering: "I.A.1)")
    show heading: it => {
            // Find out the final number of the heading counter.
            let levels = counter(heading).get()
            let deepest = if levels != () {
            levels.last()
        } else {
            1
        }

        set text(10pt, weight: 400)
        if it.level == 1 {
            // We don't want to number the acknowledgment section.
            let is-ack = it.body in (
                [Agradecimentos], 
                [AGRADECIMENTOS],
                [Referências], 
                [REFERÊNCIAS], 
                [Apêndices], 
                [APÊNDICES]
            )
            set align(center)
            set text(weight: "bold")
            show: block.with(above: 13.75pt, below: 13pt, sticky: true)
            show: upper
            if it.numbering != none and not is-ack {
                numbering("I.", deepest)
                h(7pt, weak: true)
            }
            it.body
        } else if it.level == 2 {
            set par(first-line-indent: 0pt)
            set text(style: "italic", weight: "bold")
            show: block.with(spacing: 10pt, sticky: true)
            if it.numbering != none {
                numbering("A.", deepest)
                h(7pt, weak: true)
            }
            it.body
       } else if it.level == 3 {
            show: block.with(sticky: true)
            if it.numbering != none {
                numbering("1)", deepest)
                [ ]
            }
        [_#(it.body)_]
        } else [
        _#(it.body):_
        ]
    }

    // Equações matemáticas na margem direita, com parênteses
    set math.equation(numbering: "(1)")

    // Ajustes de densidade do documento
    set list(spacing: 1mm)
    set enum(spacing: 1mm)
    set table(stroke: 0.5pt, inset: 1.5pt)
    show table: it => text(size: 8pt, it)
    show raw: it => text(size: 8pt, it)

    // O CEEL exige TODAS as legendas no TOPO da caixa
    set figure.caption(position: top)
    show figure: set block(above: 0.55em, below: 0.65em, breakable: true)
    show figure.caption: set text(size: 9pt)

    // Tabelas: Recebem suplemento "Tabela" e numeral Romano
    show figure.where(kind: table): set figure(supplement: [Tabela], numbering: "I")

    // Imagens/Gráficos: Recebem suplemento "Figura" e numeral Arábico
    show figure.where(kind: image): set figure(supplement: [Figura], numbering: "1")

    // 1. Redução tipográfica obrigatória para o corpo da tabela 
    show table: set text(size: 8pt)

    // 2. Configuração do mapeamento de bordas e alinhamento interno
    set table(
        stroke: (x, y) => (
            left: 0pt,   // Sem bordas verticais
            right: 0pt,
            // Desenha linha no teto da tabela (y=0) e no teto da segunda linha (y=1)
            top: if y <= 1 { 0.5pt } else { 0pt },
            bottom: 0pt
        ),
        // Respiro interno das células para não asfixiar o texto
        inset: (x, y) => (x: 6pt, y: 4pt),
        // Alinhamento padrão: centro horizontal e vertical
        align: center + horizon
    )

    // 3. Aplicação do selo inferior da geometria
    show table: it => block(
        // Desenha a linha de fechamento na base do bloco que contém a tabela
        stroke: (bottom: 0.5pt),
        // Garante que o bloco "abrace" exatamente o tamanho da tabela
        width: auto,
        it
    )

    place(
        top + center,
        scope: "parent",
        float: true,
        ceel-title-block(
            title: title,
            authors: authors,
            event: event,
            institution: institution,
            date: date,
            left-logo: left-logo,
            right-logo: right-logo,
        ),
    )

    ceel-abstract([Resumo], abstract)
    ceel-keywords([Palavras-Chave], keywords)

    if title-en != none {
        ceel-english-title(title-en)
    }
    if abstract-en != none {
        ceel-abstract([Abstract], abstract-en)
    }
    if keywords-en.len() > 0 {
        ceel-keywords([Keywords], keywords-en)
    }

    body
}
