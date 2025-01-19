
// ==================================  DATA  ===================================

#let frames = json("content/frames.json").map(d => d + (file_source: "frames"))
#let weapons = json("content/weapons.json").map(d => d + (file_source: "weapons"))
#let systems = json("content/systems.json").map(d => d + (file_source: "systems"))
#let mods = json("content/mods.json").map(d => d + (file_source: "weapon_mods"))
#let manufacturers = json("content/manufacturers.json").map(d => d + (file_source: "manufacturers"))
#let tag_lib = (json("data/core_tags.json") + json("content/tags.json")).map(d => d + (file_source: "tags"))
#let core_bonuses = json("content/core_bonuses.json").map(d => d + (file_source: "core_bonuses"))
#let pilot_gear = json("content/pilot_gear.json").map(d => d + (file_source: "pilot_gear"))
#let talents = json("content/talents.json").map(d => d + (file_source: "talents"))

#let equipment = weapons + systems + mods

#let LIGHT_RED = rgb("#f5253b")
#let DEFAULT_RED = rgb("c22026")
#let DARK_RED = rgb("#4e0000")

#let GLYPHS = (
  // Range
  Range: 0xe937,
  Burst: 0xe938,
  Cone: 0xe939,
  Line: 0xe93a,
  Blast: 0xe95b,
  Threat: 0xe957,

  // Dammage
  Burn: 0xe93c,
  Energy: 0xe93d,
  Explosive: 0xe93e,
  Heat: 0xe93f,
  Kinetic: 0xe940,
  Variable: 0xe941,
  variable: 0xe941,

  // Sizes
  Size_half: 0xe954,
  Size1: 0xe950,
  Size2: 0xe951,
  Size3: 0xe952,
  
  // Sizes
  Artillery: 0xe94b,
  Controller: 0xe94c,
  Striker: 0xe94d,
  Support: 0xe94e,
  Defender: 0x94f,

  // Talents
  Talent1: 0xe95c,
  Talent2: 0xe95d,
  Talent3: 0xe95e,
)

#let STAT_DISPLAY = (
  size: "Size",
  structure: "Structure",
  stress: "Stress",
  armor: "Armor",
  edef: "E-Defense",
  evasion: "Evasion",
  heatcap: "Heat",
  repcap: "Repair",
  save: "Save Target",
  sensor_range: "Sensors",
  speed: "Speed",
  hp: "HP",
  tech_attack: "Tech Attack",
  sp: "System Points",
)

#let MOUNT_NAMES = (
  Aux: "AUXILIARY",
  Main: "MAIN MOUNT",
  Flex: "FLEX MOUNT",
  Heavy: "HEAVY MOUNT",
  "Aux/Aux": "AUX/AUX",
  "Main/Aux": "MAIN/AUX",
)

#let COLOR_PALETTE = (
  weapon: (rgb("#000000"), rgb("#f2f2f2")),
  system: (rgb("#68bd45"), rgb("#e1f2da")),
  mod: (rgb("#68bd45"), rgb("#e1f2da")),
  tech: (rgb("#7e2477"), rgb("#f2e9f1")),
  reaction: (rgb("#0b7675"), rgb("#e7f1f1")),
  ai: (rgb("#d60000"), rgb("#fde8e7")),
  protocol: (rgb("#d75000"), rgb("#fceee5")),
  traits: (DEFAULT_RED, rgb("#f9e9e9")),
  pilot_gear: (rgb("#471016"), rgb("#ede7e8")),
)

// ==================================  STYLING  ===================================

#let USE_A3 = false

#let on_left_page(loc) = {calc.even(loc.page())}
#let TRAINGLE_WIDTH = 5cm
#let TRAINGLE_HEIGHT = 3cm

#let style(doc) = [
  #show heading.where(level: 1): it => (
    align(center, text(
      size: 24pt,
      fill: DEFAULT_RED, 
      strong(it)
    ))
  )
  #set text(
    font: "DM Sans",
    overhang: true
  )
  #set par(
    leading: 4pt,
  )
  #set page(
    margin: (left: 2em, right: 4.5em, top: 2em, bottom: 2em),
    background: context {
      let chapter = selector(heading).before(here())
      if (on_left_page(here())) {
        place(left + bottom, polygon(
          fill: DEFAULT_RED,
          (TRAINGLE_WIDTH, 100%),
          (0cm, 100% - TRAINGLE_HEIGHT),
          (0cm, 100%),
        ))
        place(left + bottom,
          dy: 0.1cm,
          line(
          start: (TRAINGLE_WIDTH + 0.7cm, 100%),
          angle: calc.atan(TRAINGLE_HEIGHT / TRAINGLE_WIDTH) + 180deg,
          length: 10cm,
          stroke: 0.2cm + DEFAULT_RED
        ))
      } else {
        place(right + bottom, polygon(
          fill: DEFAULT_RED,
          (100% - TRAINGLE_WIDTH, 100%),
          (100%, 100% - TRAINGLE_HEIGHT),
          (100%, 100%),
        ))
        place(right + bottom,
          dy: 0.1cm,
          line(
          start: (100% - TRAINGLE_WIDTH + 0.7cm, 100%),
          angle: -calc.atan(TRAINGLE_HEIGHT / TRAINGLE_WIDTH),
          length: 6.7cm,
          stroke: 0.2cm + DEFAULT_RED
        ))
      }},
    foreground: context [
      #let chapter = query(selector(heading.where(level: 1)).before(here())).last()
      #let chap_count = query(selector(heading.where(level: 1, outlined: true)).before(here())).len()
      #let section_query = query(selector(heading.where(level: 2)).before(here()))
      #set text(14pt, white, font: "Barlow")
      #if(on_left_page(here())) {
        place(left + bottom, 
        dx: 2em, dy: -1em,
        counter(page).display(
          "[1]",
          both: false,
        ))
      } else {
        place(right + bottom, 
        dx: -2em, dy: -1em,
        counter(page).display(
          "[1]",
          both: false,
        ))
      }
      #set text(11pt, black, font: "DM Sans")
      #if(on_left_page(here())) {
        place(left + bottom, dy: -2em, dx: TRAINGLE_WIDTH)[
          #if (section_query.len() > 0) { [*Section \/\/ * #section_query.last().body] } else { [*Chapter #chap_count \/\/ * #chapter.body] }
        ]
      } else {
        place(right + bottom, dy: -2em, dx: -TRAINGLE_WIDTH)[
          #if (section_query.len() > 0) { [*Section \/\/ * #section_query.last().body] } else { [*Chapter #chap_count \/\/ * #chapter.body] }
        ]
        // Side content
        set text(14pt, gray)
        place(top + right, dx: -1cm, dy: 3.7cm,
          rotate(-90deg, origin: top + right, 
          upper(strong(chapter.body))
        ))
        set text(64pt, gray, font: "IBM Plex Mono")
        place(right + top, dy: 0.7em, dx: 0.2em)[
          *#chap_count*
        ]
      }
    ]
  )
  #set table(
    fill: (c, r) => if c == 0 and r != 0 {black} else if calc.odd(r) {rgb("#e6e6e6")} else {white},
    stroke: none
  )
  #doc
]

// ==================================  UTILITY  ===================================

#let unescape_html(inp) = {
  // TODO: properly handle lists etc
  inp.replace("<br>", "\n").replace(regex("</?[^<>]+>"), "")  // catches 90% of relevant stuff, not robust by any means
}

#let ensure_even_pagebreak() = {
  pagebreak(weak: false)
  let s_pagebreaks = state("pagebreaks", ())
  let s_count1 = state("pageeven_count1", 0)
  let s_count2 = state("pageeven_count2", 0)
  let expected_count = frames.len() + manufacturers.len()
  context {
    if s_count1.final() < expected_count {
      // First iteration: figure out where to put pagebreaks
      s_pagebreaks.update(x => {
        let prev = x.at(-1, default: (0, 0))
        let expected_page = prev.at(1) + loc.page()
        let skipped_pages = prev.at(1) + calc.rem(expected_page, 2)
        (..x, (expected_page, skipped_pages))
      })
      s_count1.update(x => x+1)
    } else {
      // Consecutove iterations: put pagebreaks
      // Latch all the states to not update anymore, this will enforce convergance, and we can put pagebreaks in peace
      s_count1.update(9999)
      s_count2.update(x => x+1)
      let pbs = s_pagebreaks.final(loc)
      s_pagebreaks.update(x => pbs)
      let count = s_count2.at(loc)
      if not calc.even(pbs.at(count, 1).at(0)) {
        pagebreak()
      }
    } 
  }
}

#let as_a3(body) = {
  page(
    paper: "a3",
    flipped: true,
    columns: 2, 
    body
  )
}

#let lancer_glyph(key) = {
  text(font: "compcon", fallback: false,
    str.from-unicode(GLYPHS.at(key, default:0x0000))
  )
}

#let box_display(name, header1, header2, body, color_tuple) = {
  box(
    stroke: 0pt,
    inset: 0pt,
    stack(dir: ttb,
      rect(
        text(fill: white, 
          heading(level: 4, bookmarked: false, upper(name)) + 
          if header1.len() > 0 {header1.join(h(10pt))} + 
          if header2.len() > 0 {linebreak() + header2.join(h(10pt))}
        ),
        width: 100%, stroke: 0pt, fill: color_tuple.first()
      ),
      rect(body, width: 100%, stroke: 0pt, fill: color_tuple.last())
    )
  )
}

#let compleate_tags(equipment) = {
  let ACTIVATION_TAGS = (
    "Quick": "tg_quick_action",
    "Full": "tg_full_action",
    "Quick Tech": "tg_quick_tech",
    "Full Tech": "tg_full_tech",
    "Invade": "tg_invade",
    "Reaction": "tg_reaction",
    "Free": "tg_free_action",
    "Protocol": "tg_protocol",
  )
  let res = equipment.at("tags", default: ())
  if "deployables" in equipment { res.insert(0, (id: "tg_deployable")) }
  for action in equipment.at("actions", default:()) {
      let tag = ACTIVATION_TAGS.at(action.at("activation", default: "Quick"))
    	if not res.any(x => x.id == tag) { res.insert(0, (id: tag)) }
  }
  res
}

#let translate_size_glyph(size_num) = {
  if size_num == 0.5 { "Size_half" }
  else if size_num == 2 { "Size2" }
  else if size_num == 3 { "Size3" }
  else { "Size1" }
}

#let translate_talent_glyph(talent_level) = ("Talent1", "Talent2", "Talent3").at(talent_level - 1, default: "Talent1")

#let format_tags(tags) = {
  tags.map(tag => {
    let name = tag_lib.find(x => x.id == tag.id).name
    if "val" in tag and "{VAL}" in name {
      name.replace("{VAL}", str(tag.val))
    }
    else {
      name
    }
  })
}

#let format_range(range_data) = {
  if "val" in range_data and "type" in range_data {
    lancer_glyph(range_data.type) + h(5pt) + [#range_data.val] + h(8pt)
  } else {
    [INVALID]
  }
}

#let format_dmg(dmg_data) = {
  if "val" in dmg_data and "type" in dmg_data {
    [#dmg_data.val] + h(5pt) + lancer_glyph(dmg_data.type) + h(8pt)
  } else {
    [INVALID]
  }
}

// ==================================  EQUIPMENT  ===================================

#let display_reaction(reaction_data) = {
  box(
  stack(dir: ttb,
    rect(
      width: 100%, stroke: 0pt, fill: COLOR_PALETTE.reaction.first(),
      text(fill: white, heading(level: 3, bookmarked: false, reaction_data.at("name", default:"")) + [Reaction] + h(10pt) + reaction_data.at("frequency", default:"Unlimited"))
    ),
    rect(
      width: 100%, stroke: 0pt, fill: white,
      text(fill: black, [*Trigger:* ] + reaction_data.at("trigger", default:""))
    ),
    rect(
      width: 100%, stroke: 0pt, fill: COLOR_PALETTE.reaction.last(),
      text(fill: black, [*Effect:* ] + reaction_data.at("detail", default:""))
    )
  ))
}

#let display_weapon(weapon_data) = {
  let body = unescape_html(weapon_data.at("effect_print", default: weapon_data.at("effect", default:"")))
  if weapon_data.at("description", default:"") != "" {
    body = body + line(length: 100%, stroke: (dash: "densely-dashed")) + emph(unescape_html(weapon_data.description))
  }
  let header1 = (weapon_data.mount, weapon_data.type, ..format_tags(compleate_tags(weapon_data)))
  if "sp" in weapon_data {
    header1 = (str(weapon_data.sp) + " SP", ..header1)
  }
  if "on_crit" in weapon_data {
    body = [*On Critical hit:* ] + weapon_data.on_crit + linebreak() + body
  }
  if "on_hit" in weapon_data {
    body = [*On Hit:* ] + weapon_data.on_hit + linebreak() + body
  }
  if "on_attack" in weapon_data {
    body = [*On Attack:* ] + weapon_data.on_attack + linebreak() + body
  }
  let profile_data = if "profiles" in weapon_data {weapon_data.profiles.at(0)} else {weapon_data}
  let header2 = (
    profile_data.at("range", default: ()).map(format_range).join(), 
    profile_data.at("damage", default: ()).map(format_dmg).join()
  )
  box_display(weapon_data.name, header1, header2, body, COLOR_PALETTE.weapon)
}

#let display_tech_system(system_data) = {
  let body = unescape_html(system_data.at("effect_print", default: system_data.at("effect", default:"No effect")))
  for action in system_data.at("actions", default:()) {
    body += rect(
      stroke: (
        "top": 2pt + COLOR_PALETTE.tech.first(),
        "bottom": 2pt + COLOR_PALETTE.tech.first(),
        "left": 0pt,
        "right": 0pt
      ),
      fill: white,
      outset: 5pt,
      width: 100%
    )[*#action.at("name", default:"UNNAMED")*: #action.detail]
  }
  if system_data.at("description", default:"") != "" {
    body = body + line(length: 100%, stroke: (dash: "densely-dashed")) + emph(unescape_html(system_data.description))
  }
  let header = (str(system_data.sp) + " SP", ..format_tags(compleate_tags(system_data)))
  box_display(system_data.name, header, (), body, COLOR_PALETTE.tech)
}

#let display_nontech_system(system_data) = {
  let body = unescape_html(system_data.at("effect_print", default: system_data.at("effect", default:"No effect")))
  let colors = COLOR_PALETTE.system
  if system_data.at("actions", default: ()).any(x => x.at("activation", default: "Quick") == "Protocol") {
    colors = COLOR_PALETTE.protocol
  }
  if system_data.at("type", default: "System") == "AI" {
    colors = COLOR_PALETTE.ai
  }
  if system_data.at("description", default:"") != "" {
    body = body + line(length: 100%, stroke: (dash: "densely-dashed")) + emph(unescape_html(system_data.description))
  }
  let header = (str(system_data.sp) + " SP", ..format_tags(compleate_tags(system_data)))
  box_display(system_data.name, header, (), body, colors)
}

#let display_system(system_data) = {
  if system_data.at("type", default: "System") == "Tech" {
    display_tech_system(system_data)
  } else {
    display_nontech_system(system_data)
  }
}

#let display_weapon_mod(mod_data) = {
  let body = unescape_html(mod_data.at("effect_print", default: mod_data.at("effect", default:"No effect")))
  if mod_data.at("description", default:"") != "" {
    body = body + line(length: 100%, stroke: (dash: "densely-dashed")) + unescape_html( mod_data.description)
  }
  box_display(mod_data.name, (), (), body, COLOR_PALETTE.mod)
}

// ==================================  FRAME  ===================================

#let display_stats(stat_dict) = {
  let disp(stat_id) = {
    STAT_DISPLAY.at(stat_id) + " :" + h(5pt) + str(stat_dict.at(stat_id))
  }
  let stat_heading(name) = text(fill: DEFAULT_RED, strong(name))
  heading(level: 2, bookmarked: false)[STATS]
  //grid(columns: 2, ..STAT_DISPLAY.pairs().map(
  //p => p.last() + v(-7pt) + str(stat_dict.at(p.first()))
  //))
  grid(columns: 2, row-gutter: 8pt, column-gutter: 15pt,
  disp("size"), disp("save"),
  disp("armor"), disp("sensor_range"),
  stat_heading("HULL"), stat_heading("SYSTEMS"),
  h(15pt) + disp("hp"), h(15pt) + disp("edef"),
  h(15pt) + disp("repcap"), h(15pt) + disp("tech_attack"),
  stat_heading("AGILITY"), h(15pt) + disp("sp"),
  h(15pt) + disp("evasion"), stat_heading("ENGINEERING"),
  h(15pt) + disp("speed"), h(15pt) + disp("heatcap"),
  )
  linebreak()
}

#let display_traits(trait_list) = {
  heading(level: 2, bookmarked: false)[TRAITS]
  for trait in trait_list {
    box_display(trait.name, (), (), trait.description, COLOR_PALETTE.traits)
  }
}

#let display_mounts(mount_list) = {
  heading(level: 2, bookmarked: false)[MOUNTS]
  grid(columns: (33%, 33%, 33%), column-gutter: 10pt, ..mount_list.map(
    x => box(
      fill: DEFAULT_RED, width: 100%, inset: 10pt,
      align(center, text(fill: white, size: 15pt, strong(MOUNT_NAMES.at(x))))
    )
  ))
}

#let display_core_system(core) = {
  heading(level: 2, bookmarked: false)[CORE SYSTEM]
  heading(level: 3, core.name, bookmarked: false)
  par(unescape_html(core.at("description", default:"")), justify: true)
  for integrated_id in core.at("integrated", default:()){
    display_weapon(weapons.find(d => d.id == integrated_id))
  }
  let colors = COLOR_PALETTE.system
  if core.activation == "Protocol" { colors = COLOR_PALETTE.protocol }
  box_display(core.active_name, ("Active (1 CP)", core.activation), (), par(unescape_html(core.active_effect)), colors)
  for action in core.at("actions", default:()) {
    if action.at("activation", default: "Quick") == "Reaction" {
      display_reaction(action)
    }
  }
}

#let _frame_box(frame_data) = box({
  // Title
  hide(heading(level: 2, frame_data.name))
  align(center, stack(dir: ttb, 
    text(font: "Barlow", fill: DEFAULT_RED, weight: "extralight", size: 24pt, frame_data.source) + v(1em),
    text(fill: DEFAULT_RED, size: 24pt, frame_data.name) + v(1em),
    text(fill: DEFAULT_RED, frame_data.mechtype.join("/")),
  ))
  // Icons
  place(
    top + left,
    stack(
      text(fill: DEFAULT_RED, size: 32pt, lancer_glyph(translate_size_glyph(frame_data.stats.size))),
      ..frame_data.mechtype.map(x => text(fill: DEFAULT_RED, size: 32pt, lancer_glyph(x)))
    )
  )
  // Flavor
  grid(
    columns:(3em, auto, 3em),  // Hack to get variable page margins 
    [], par(unescape_html(frame_data.description), justify: true), []
  )
  // Mechanics
  rect(stroke: DEFAULT_RED + 2pt,
  rect(stroke: DEFAULT_RED + 2pt,
    columns(2,
      display_stats(frame_data.stats) + 
      display_traits(frame_data.traits) + 
      display_mounts(frame_data.mounts) +
      colbreak() +
      display_core_system(frame_data.core_system)
    )
  ))
})

#let display_frame(frame_data) = {
  //let manufacturer_data = manufacturers.find(x => x.id == frame_data.source)
  //let bg_img = if manufacturer_data != none and "logo_path" in manufacturer_data {"artwork/blackbox.png"} else {none}
  if USE_A3 {
    as_a3({
      _frame_box(frame_data)
      colbreak()
      if "img_path" in frame_data {
        align(center, image(frame_data.img_path, height: 95%))
      }
    })
  } else {
    _frame_box(frame_data)
    if "img_path" in frame_data {
      pagebreak()
      align(center, image(frame_data.img_path, height: 95%))
    }
  }
}

#let _license_box(frame_name, license_id) = {
  let license_counter = counter("license")
  counter("license").update(1)
  let license_box(color, content) = {
    set text(fill: white, size: 12pt)
    box(fill: color, inset: 5pt, width: 100%, [License]
    + context license_counter.display(" I: ") + content.map(
      x => x.name
    ).join([, ])) + linebreak()
    license_counter.step()
  }
  let lls = range(1, 4).map(x => equipment.filter(d => d.at("license_id", default:"") == license_id and d.at("license_level", default:-999) == x))
  // Print licence structure
  columns(2, 
  for i in range(3){
    license_box((LIGHT_RED, DEFAULT_RED, DARK_RED).at(i), lls.at(i))
    for equipment in lls.at(i){
      if equipment.file_source == "weapons" { display_weapon(equipment) }
      if equipment.file_source == "systems" { display_system(equipment) }
      if equipment.file_source == "weapon_mods" { display_weapon_mod(equipment) }
      for action in equipment.at("actions", default:()) {
        if action.at("activation", default: "Quick") == "Reaction" {
          display_reaction(action)
        }
      }
    }
  })
}

#let display_license(frame_name, license_id) = {
  if USE_A3 {
    as_a3(
      _license_box(frame_name, license_id)
    )}
  else {_license_box(frame_name, license_id)}
}


// ==================================  LICENSE-INDEPENDANT  ===================================

#let display_manufacturer(manufacturer) = {
  [= #manufacturer.name]
  columns(2, {
    emph(unescape_html(manufacturer.quote))
    linebreak()
    par(unescape_html(manufacturer.description), justify: true)

    set heading(bookmarked: false)
    [== #manufacturer.name Core Bonuses]
    for bonus in core_bonuses.filter(x => x.source == manufacturer.id) {
      box_display(bonus.name, (), (), {
        par(emph(unescape_html(bonus.description)), justify: true)
        par(unescape_html(bonus.effect), justify: true)
      }, (DEFAULT_RED, white))
    }
    if "artwork_path" in manufacturer {
      image(manufacturer.artwork_path, fit: "contain")
    }
  })
}

#let display_talets() = if talents.len() > 0 {
  let TALENT_COLOR = rgb("#3a82c4")
  pagebreak()
  [= Talents]
  let rnk_count = counter("TalentRank")
  columns(2, 
    for talent in talents {
      box_display(text(size: 16pt, strong(upper(talent.name))), (), (), {
        par(emph(unescape_html(talent.description)), justify: true)
        v(1em)
        rnk_count.update(0)
        talent.ranks.map(rank => {
          line(length: 100%, stroke: 2pt + TALENT_COLOR)
          rnk_count.step()
          context rnk_count.display(x => text(fill: TALENT_COLOR, size: 20pt, lancer_glyph(translate_talent_glyph(x))))
          h(.5em) + text(size: 16pt, strong(upper(rank.name)))
          par(unescape_html(rank.description), justify: true)
          rank.at("actions", default:()).filter(x => x.activation == "Reaction").map(display_reaction).join()
        }).join()
      }, (TALENT_COLOR, white))
    }
  )
}

#let display_pilotgear() = if pilot_gear.len() > 0 {
  pagebreak()
  [= Gear]

  let get_pilot_bonus(data, id, default: 0) = {
    let f = data.find(x => x.id == id) 
    if f == none {default} else {f.at("val", default: default)}
  }

  let armor_table = pilot_gear.filter(x => x.type == "Armor").map(x => (
    text(fill: white, upper(strong(x.name))),
    smallcaps(format_tags(x.at("tags", default: ())).join()),
    [#get_pilot_bonus(x.at("bonuses", default: ()), "pilot_armor")],
    [#get_pilot_bonus(x.at("bonuses", default: ()), "pilot_evasion")],
    [#get_pilot_bonus(x.at("bonuses", default: ()), "pilot_edef")],
    [#get_pilot_bonus(x.at("bonuses", default: ()), "pilot_speed")],
  )).flatten()
  
  let weapon_table = pilot_gear.filter(x => x.type == "Weapon").map(x => (
    text(fill: white, upper(strong(x.name))), 
    smallcaps(format_tags(x.at("tags", default: ())).join(", ")), 
    x.range.map(format_range).join(" "), 
    x.damage.map(format_dmg).join(" "),
  )).flatten()

  if armor_table.len() > 0 {table(
    columns: 6,
    ..([], [Tags], [Armor], [Evasion], [E-Defense], [Speed]).map(strong),
    ..armor_table
  )}
  columns(2,{
    if weapon_table.len() > 0 {table(
      columns: 4,
      ..([], [Tags], [Range], [Damage]).map(strong), 
      ..weapon_table
    )}
    for gear in pilot_gear.filter(x => x.type not in ("Weapon", "Armor")) {
      box_display(
        text(size: 16pt, strong(upper(gear.name))), 
        format_tags(gear.at("tags", default: ())), (), {
        par(emph(gear.description), justify: true)
        v(1em)
        par(gear.at("effect_print", default: gear.at("effect", default: "NO EFFECT")), justify: true)
        gear.at("actions", default: ()).filter(x => x.activation == "Reaction").map(display_reaction).join()
      }, COLOR_PALETTE.pilot_gear)
    }
  })
}

#let display_gms_equipment() = {
  let gms_equipment = equipment.filter(x => x.at("license", default:"") == "GMS")
  if gms_equipment.len() > 0 {
    [= GMS ADDENDUM]

    let weapon_table = gms_equipment.filter(x => x.file_source == "weapons").map(x => (
      text(fill: white, upper(strong(x.name))),
      x.mount + " " + x.type,
      smallcaps(format_tags(x.at("tags", default: ())).join()), 
      x.range.map(format_range).join(), 
      x.damage.map(format_dmg).join(),
    )).flatten()

    if weapon_table.len() > 0 {table(
      columns: 5,
      ..([Name], [Size / Type], [Tags], [Range], [Damage]).map(strong), 
      ..weapon_table
    )}
  }
  columns(2, {
    for sys in gms_equipment.filter(x => x.file_source == "systems") {
      display_system(sys)
    }
  })
}

// ==================================  FILE  ===================================

#let display_whole() = {
  display_talets()
  display_pilotgear()
  display_gms_equipment()
  for manufacturer in manufacturers {
    ensure_even_pagebreak()
    display_manufacturer(manufacturer)
    for frame_data in frames.filter(x => x.source == manufacturer.id) {
      ensure_even_pagebreak()
      display_frame(frame_data)
      pagebreak()
      display_license(frame_data.name, frame_data.license_id)
    }
  }  
}

#par(leading: 8pt, outline(depth: 1))
//#grid(columns: 6, ..range(0xe900, 0xe96b).map(x => {
//  [#str(x, base:16)] + text(font: "compcon", fallback: false, str(x, base:16) + str.from-unicode(x) + "\n")
//}))  // Test font
#show: style
#display_whole()