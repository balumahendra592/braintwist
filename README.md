const {
Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
HeadingLevel, AlignmentType, BorderStyle, WidthType, ShadingType,
LevelFormat, PageBreak, TabStopType, TabStopPosition
} = require('docx');
const fs = require('fs');

// ── Colors ──────────────────────────────────────────────────────────
const PURPLE     = '7C3AED';
const PURPLE_L   = 'EDE9FE';
const PURPLE_D   = '3B0764';
const TEAL       = '059669';
const TEAL_L     = 'D1FAE5';
const AMBER      = 'D97706';
const AMBER_L    = 'FEF3C7';
const RED_L      = 'FEE2E2';
const RED        = 'DC2626';
const GRAY_L     = 'F3F4F6';
const GRAY_M     = 'E5E7EB';
const GRAY_D     = '374151';
const GRAY_MID   = '6B7280';
const BLACK      = '111827';
const WHITE      = 'FFFFFF';

// ── Border helpers ──────────────────────────────────────────────────
const border = (color = GRAY_M, size = 4) => ({ style: BorderStyle.SINGLE, size, color });
const allBorders = (color = GRAY_M, size = 4) => ({
top: border(color, size), bottom: border(color, size),
left: border(color, size), right: border(color, size)
});
const noBorders = () => ({
top: { style: BorderStyle.NONE, size: 0, color: WHITE },
bottom: { style: BorderStyle.NONE, size: 0, color: WHITE },
left: { style: BorderStyle.NONE, size: 0, color: WHITE },
right: { style: BorderStyle.NONE, size: 0, color: WHITE },
});
const bottomBorder = (color = PURPLE, size = 8) => ({
top: { style: BorderStyle.NONE, size: 0, color: WHITE },
bottom: border(color, size),
left: { style: BorderStyle.NONE, size: 0, color: WHITE },
right: { style: BorderStyle.NONE, size: 0, color: WHITE },
});

// ── Text helpers ─────────────────────────────────────────────────────
const run = (text, opts = {}) => new TextRun({ text, font: 'Arial', ...opts });
const bold = (text, opts = {}) => run(text, { bold: true, ...opts });
const colored = (text, color, opts = {}) => run(text, { color, ...opts });
const boldColored = (text, color, opts = {}) => run(text, { bold: true, color, ...opts });

const para = (children, opts = {}) => new Paragraph({
children: Array.isArray(children) ? children : [children],
...opts
});
const space = (before = 120, after = 60) => para([run('')], { spacing: { before, after } });

// ── Cell helpers ─────────────────────────────────────────────────────
const cell = (children, opts = {}) => new TableCell({
children: Array.isArray(children) ? children : [children],
margins: { top: 100, bottom: 100, left: 140, right: 140 },
...opts
});
const headerCell = (text, bgColor = PURPLE, textColor = WHITE, width = 2340) =>
cell([para([boldColored(text, textColor, { size: 20 })])], {
shading: { fill: bgColor, type: ShadingType.CLEAR },
borders: allBorders(bgColor, 2),
width: { size: width, type: WidthType.DXA },
});
const dataCell = (children, bgColor = WHITE, width = 2340, borders = allBorders()) =>
cell(Array.isArray(children) ? children : [para(Array.isArray(children) ? children : [typeof children === 'string' ? run(children, { size: 18 }) : children])], {
shading: { fill: bgColor, type: ShadingType.CLEAR },
borders,
width: { size: width, type: WidthType.DXA },
});

// ── Section heading ──────────────────────────────────────────────────
const sectionHeading = (text) => [
space(280, 0),
new Paragraph({
heading: HeadingLevel.HEADING_1,
children: [boldColored(text, WHITE, { size: 28 })],
shading: { fill: PURPLE_D, type: ShadingType.CLEAR },
border: { bottom: border(PURPLE, 6) },
indent: { left: 160, right: 160 },
spacing: { before: 0, after: 0 },
}),
space(60, 0),
];

const subHeading = (text) => [
space(180, 0),
new Paragraph({
heading: HeadingLevel.HEADING_2,
children: [boldColored(text, PURPLE_D, { size: 24 })],
border: { bottom: border(PURPLE, 4) },
spacing: { before: 0, after: 60 },
}),
space(40, 0),
];

const subSubHeading = (text) => [
space(120, 0),
new Paragraph({
heading: HeadingLevel.HEADING_3,
children: [boldColored(text, GRAY_D, { size: 22 })],
spacing: { before: 0, after: 40 },
}),
];

// ── Code block ────────────────────────────────────────────────────────
const codeBlock = (lines) => {
const rows = lines.map(line =>
new TableRow({
children: [
new TableCell({
children: [new Paragraph({
children: [new TextRun({ text: line || ' ', font: 'Courier New', size: 17, color: PURPLE })],
spacing: { before: 20, after: 20 },
})],
borders: noBorders(),
margins: { top: 40, bottom: 40, left: 200, right: 200 },
})
]
})
);
return new Table({
width: { size: 9360, type: WidthType.DXA },
columnWidths: [9360],
rows,
borders: allBorders(PURPLE_L, 4),
shading: { fill: 'F5F3FF', type: ShadingType.CLEAR },
});
};

// ── Info box ──────────────────────────────────────────────────────────
const infoBox = (label, text, bg = AMBER_L, labelColor = AMBER, textColor = GRAY_D) =>
new Table({
width: { size: 9360, type: WidthType.DXA },
columnWidths: [1400, 7960],
rows: [new TableRow({
children: [
new TableCell({
children: [para([boldColored(label, labelColor, { size: 18 })])],
shading: { fill: bg, type: ShadingType.CLEAR },
borders: allBorders(labelColor, 4),
margins: { top: 100, bottom: 100, left: 140, right: 140 },
width: { size: 1400, type: WidthType.DXA },
}),
new TableCell({
children: [para([run(text, { size: 18, color: textColor })])],
shading: { fill: bg, type: ShadingType.CLEAR },
borders: allBorders(labelColor, 4),
margins: { top: 100, bottom: 100, left: 140, right: 140 },
width: { size: 7960, type: WidthType.DXA },
}),
]
})],
});

// ── Bullet list item ─────────────────────────────────────────────────
const bullet = (text, color = PURPLE) => new Paragraph({
numbering: { reference: 'bullets', level: 0 },
children: [run(text, { size: 20, color: GRAY_D })],
spacing: { before: 40, after: 40 },
});
const checkItem = (label, detail, done = true) => new Paragraph({
numbering: { reference: 'checks', level: 0 },
children: [
boldColored(label + ': ', done ? TEAL : AMBER, { size: 20 }),
run(detail, { size: 20, color: GRAY_D }),
],
spacing: { before: 40, after: 40 },
});

// ════════════════════════════════════════════════════════════════════
// DOCUMENT BUILD
// ════════════════════════════════════════════════════════════════════

const doc = new Document({
numbering: {
config: [
{
reference: 'bullets',
levels: [{
level: 0, format: LevelFormat.BULLET, text: '•',
alignment: AlignmentType.LEFT,
style: { paragraph: { indent: { left: 560, hanging: 280 } } },
}],
},
{
reference: 'numbers',
levels: [{
level: 0, format: LevelFormat.DECIMAL, text: '%1.',
alignment: AlignmentType.LEFT,
style: { paragraph: { indent: { left: 560, hanging: 280 } } },
}],
},
{
reference: 'checks',
levels: [{
level: 0, format: LevelFormat.BULLET, text: '✓',
alignment: AlignmentType.LEFT,
style: { paragraph: { indent: { left: 560, hanging: 280 } } },
}],
},
],
},
styles: {
default: {
document: { run: { font: 'Arial', size: 20, color: BLACK } },
},
paragraphStyles: [
{
id: 'Heading1', name: 'Heading 1', basedOn: 'Normal', next: 'Normal', quickFormat: true,
run: { size: 28, bold: true, font: 'Arial', color: WHITE },
paragraph: { spacing: { before: 200, after: 100 }, outlineLevel: 0 },
},
{
id: 'Heading2', name: 'Heading 2', basedOn: 'Normal', next: 'Normal', quickFormat: true,
run: { size: 24, bold: true, font: 'Arial', color: PURPLE_D },
paragraph: { spacing: { before: 160, after: 80 }, outlineLevel: 1 },
},
{
id: 'Heading3', name: 'Heading 3', basedOn: 'Normal', next: 'Normal', quickFormat: true,
run: { size: 22, bold: true, font: 'Arial', color: GRAY_D },
paragraph: { spacing: { before: 120, after: 60 }, outlineLevel: 2 },
},
],
},
sections: [{
properties: {
page: {
size: { width: 12240, height: 15840 },
margin: { top: 1000, right: 1080, bottom: 1000, left: 1080 },
},
},
children: [

      // ════════════════════════════════════════
      // COVER PAGE
      // ════════════════════════════════════════
      space(800, 0),
      new Paragraph({
        alignment: AlignmentType.CENTER,
        children: [boldColored('BRAIN TWIST', PURPLE, { size: 72 })],
        spacing: { before: 0, after: 60 },
      }),
      new Paragraph({
        alignment: AlignmentType.CENTER,
        children: [boldColored('Flutter Game — Complete Project Document', PURPLE_D, { size: 28 })],
        spacing: { before: 0, after: 200 },
      }),
      new Paragraph({
        alignment: AlignmentType.CENTER,
        children: [run('Version 1.0  |  First Release Plan  |  8-Week Build Timeline', { size: 22, color: GRAY_MID })],
        spacing: { before: 0, after: 80 },
      }),
      new Paragraph({
        alignment: AlignmentType.CENTER,
        children: [run('Brain Test-style Tricky Puzzle Game with Google AdMob Monetization', { size: 22, color: GRAY_MID })],
        spacing: { before: 0, after: 400 },
      }),

      // Cover stats table
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [3120, 3120, 3120],
        rows: [
          new TableRow({ children: [
            headerCell('75 Puzzles', PURPLE, WHITE, 3120),
            headerCell('6 Screens', PURPLE, WHITE, 3120),
            headerCell('8 Weeks', PURPLE, WHITE, 3120),
          ]}),
          new TableRow({ children: [
            dataCell([para([run('3 chapters of 25', { size: 18, color: GRAY_D })])], PURPLE_L, 3120, allBorders(PURPLE, 2)),
            dataCell([para([run('Splash to Settings', { size: 18, color: GRAY_D })])], PURPLE_L, 3120, allBorders(PURPLE, 2)),
            dataCell([para([run('Launch ready', { size: 18, color: GRAY_D })])], PURPLE_L, 3120, allBorders(PURPLE, 2)),
          ]}),
        ],
      }),

      space(400, 0),
      new Paragraph({ children: [new PageBreak()] }),

      // ════════════════════════════════════════
      // 1. PROJECT OVERVIEW
      // ════════════════════════════════════════
      ...sectionHeading('1. Project Overview'),

      para([run('Brain Twist is a Flutter-based mobile puzzle game inspired by Brain Test: Tricky Puzzles. The game features 75 offline-playable brain teasers across 3 difficulty chapters, monetized through Google AdMob (banner, interstitial, and rewarded video ads).', { size: 20, color: GRAY_D })], { spacing: { before: 0, after: 160 } }),

      ...subHeading('1.1 Game Concept'),
      para([run('Players solve tricky, logic-defying puzzles that challenge assumptions. The game rewards lateral thinking, not straightforward logic. Each puzzle has a surprising answer that feels obvious in hindsight — making players share it with friends and family.', { size: 20, color: GRAY_D })], { spacing: { after: 120 } }),

      ...subHeading('1.2 Target Audience'),
      bullet('Age 8 and above — suitable for all ages'),
      bullet('Casual gamers who play in short sessions (5–15 minutes)'),
      bullet('Players who enjoy sharing puzzles with others'),
      bullet('Indian market focus — Hindi-friendly puzzle concepts'),
      space(80, 0),

      ...subHeading('1.3 Revenue Model'),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [2000, 3000, 2160, 2200],
        rows: [
          new TableRow({ children: [
            headerCell('Ad Type', PURPLE, WHITE, 2000),
            headerCell('Placement', PURPLE, WHITE, 3000),
            headerCell('CPM (India)', PURPLE, WHITE, 2160),
            headerCell('Priority', PURPLE, WHITE, 2200),
          ]}),
          new TableRow({ children: [
            dataCell('Banner', WHITE, 2000),
            dataCell('Bottom of Home + Game screen', WHITE, 3000),
            dataCell('₹5–15', WHITE, 2160),
            dataCell('Low', WHITE, 2200),
          ]}),
          new TableRow({ children: [
            dataCell('Interstitial', GRAY_L, 2000),
            dataCell('Between every 3 levels', GRAY_L, 3000),
            dataCell('₹20–60', GRAY_L, 2160),
            dataCell([para([boldColored('High', TEAL, { size: 18 })])], GRAY_L, 2200),
          ]}),
          new TableRow({ children: [
            dataCell('Rewarded Video', WHITE, 2000),
            dataCell('Watch ad to get hint coins', WHITE, 3000),
            dataCell('₹40–100', WHITE, 2160),
            dataCell([para([boldColored('Highest', PURPLE, { size: 18 })])], WHITE, 2200),
          ]}),
        ],
      }),
      space(160, 0),

      new Paragraph({ children: [new PageBreak()] }),

      // ════════════════════════════════════════
      // 2. TECH STACK
      // ════════════════════════════════════════
      ...sectionHeading('2. Tech Stack & Dependencies'),

      ...subHeading('2.1 Core Technologies'),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [2600, 3400, 3360],
        rows: [
          new TableRow({ children: [
            headerCell('Technology', PURPLE, WHITE, 2600),
            headerCell('Version / Detail', PURPLE, WHITE, 3400),
            headerCell('Purpose', PURPLE, WHITE, 3360),
          ]}),
          ...[
            ['Flutter', 'Channel stable, 3.29.2+', 'Cross-platform UI framework'],
            ['Dart', '>=3.0.0 <4.0.0', 'Programming language'],
            ['shared_preferences', '^2.2.3', 'Offline data storage (no DB needed)'],
            ['google_mobile_ads', '^4.0.0', 'AdMob banner / interstitial / rewarded'],
            ['provider', '^6.1.2', 'State management'],
            ['audioplayers', '^5.2.1', 'Sound effects (win, wrong, hint)'],
            ['lottie', '^3.1.0', 'Win / Lose animations'],
            ['flutter_animate', '^4.5.0', 'Smooth screen transitions'],
          ].map((row, i) => new TableRow({ children: row.map((text, j) =>
            dataCell(text, i % 2 === 0 ? WHITE : GRAY_L, [2600, 3400, 3360][j])
          )})),
        ],
      }),
      space(160, 0),

      ...subHeading('2.2 pubspec.yaml (Complete)'),
      codeBlock([
        'name: brain_twist',
        'description: Tricky brain puzzle game',
        'publish_to: none',
        'version: 1.0.0+1',
        '',
        'environment:',
        '  sdk: ">=3.0.0 <4.0.0"',
        '',
        'dependencies:',
        '  flutter:',
        '    sdk: flutter',
        '  shared_preferences: ^2.2.3',
        '  provider: ^6.1.2',
        '  google_mobile_ads: ^4.0.0',
        '  audioplayers: ^5.2.1',
        '  lottie: ^3.1.0',
        '  flutter_animate: ^4.5.0',
        '',
        'flutter:',
        '  uses-material-design: true',
        '  assets:',
        '    - assets/animations/',
        '    - assets/sounds/',
      ]),
      space(160, 0),

      new Paragraph({ children: [new PageBreak()] }),

      // ════════════════════════════════════════
      // 3. FOLDER STRUCTURE
      // ════════════════════════════════════════
      ...sectionHeading('3. Project Folder Structure'),

      codeBlock([
        'brain_twist/',
        '├── lib/',
        '│   ├── main.dart                          ← App entry point',
        '│   ├── theme/',
        '│   │   └── app_theme.dart                 ← Colors, fonts, button styles',
        '│   ├── models/',
        '│   │   └── puzzle_model.dart              ← Puzzle data class + PuzzleType enum',
        '│   ├── data/',
        '│   │   └── puzzle_repository.dart         ← All 75 puzzles',
        '│   ├── services/',
        '│   │   ├── game_storage.dart              ← SharedPreferences (no DB needed)',
        '│   │   └── ad_manager.dart                ← AdMob banner/interstitial/rewarded',
        '│   ├── screens/',
        '│   │   ├── splash_screen.dart',
        '│   │   ├── home_screen.dart',
        '│   │   ├── level_select_screen.dart',
        '│   │   ├── game_screen.dart',
        '│   │   ├── settings_screen.dart',
        '│   │   └── result_overlay.dart',
        '│   └── widgets/',
        '│       └── puzzle_widgets/',
        '│           ├── multi_choice_puzzle.dart   ← 4 option buttons (35 puzzles)',
        '│           ├── tap_target_puzzle.dart     ← Tap a specific element (15 puzzles)',
        '│           ├── drag_drop_puzzle.dart      ← Drag to correct zone (10 puzzles)',
        '│           ├── type_answer_puzzle.dart    ← Keyboard text input (10 puzzles)',
        '│           └── visual_trick_puzzle.dart   ← Outside-the-box tap (5 puzzles)',
        '├── assets/',
        '│   ├── animations/',
        '│   │   ├── win.json                       ← Lottie confetti animation',
        '│   │   └── lose.json                      ← Lottie sad animation',
        '│   └── sounds/',
        '│       ├── correct.mp3',
        '│       ├── wrong.mp3',
        '│       └── hint.mp3',
        '├── android/',
        '│   └── app/',
        '│       └── AndroidManifest.xml            ← AdMob App ID goes here',
        '└── pubspec.yaml',
      ]),
      space(160, 0),

      new Paragraph({ children: [new PageBreak()] }),

      // ════════════════════════════════════════
      // 4. SCREENS
      // ════════════════════════════════════════
      ...sectionHeading('4. Screens — What to Build'),

      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [400, 1800, 3160, 1800, 2200],
        rows: [
          new TableRow({ children: [
            headerCell('#', PURPLE, WHITE, 400),
            headerCell('Screen', PURPLE, WHITE, 1800),
            headerCell('Key Components', PURPLE, WHITE, 3160),
            headerCell('Navigation', PURPLE, WHITE, 1800),
            headerCell('Priority', PURPLE, WHITE, 2200),
          ]}),
          ...[
            ['1', 'Splash Screen', 'App logo, brain animation (Lottie), 2s auto-navigate, init AdMob + SharedPrefs here', 'Auto → Home', 'Must have'],
            ['2', 'Home Screen', 'App name, total score, coins display, Play button, 3 chapter cards with star ratings, banner ad at bottom, rate-us prompt after 5 sessions', 'Play → Level Select\nSettings icon → Settings', 'Must have'],
            ['3', 'Level Select', '75 level buttons in a 5-column grid, locked (grey + lock icon) vs unlocked (purple + stars), chapter sections, scroll view', 'Level tap → Game Screen\nBack → Home', 'Must have'],
            ['4', 'Game Screen', 'Question text, puzzle widget area (swappable per puzzle type), hint button with coin cost, progress bar, coin counter, back button, banner ad at bottom', 'Win/Lose → Result Overlay\nBack → Level Select', 'Must have'],
            ['5', 'Result Overlay', 'Full-screen overlay (not a new route), stars earned (1-3), coins earned, Next Level button, Watch Ad for coins button, interstitial fires here every 3 levels', 'Next Level → Game Screen\nHome → Home Screen', 'Must have'],
            ['6', 'Settings Screen', 'Sound toggle, Music toggle, Vibration toggle, Reset Progress button (with confirmation dialog), Privacy Policy link (required for Play Store), App version', 'Back → Home', 'Must have'],
          ].map((row, i) => new TableRow({ children: [
            dataCell(row[0], i % 2 === 0 ? WHITE : GRAY_L, 400),
            dataCell([para([boldColored(row[1], PURPLE_D, { size: 18 })])], i % 2 === 0 ? WHITE : GRAY_L, 1800),
            dataCell(row[2], i % 2 === 0 ? WHITE : GRAY_L, 3160),
            dataCell(row[3], i % 2 === 0 ? WHITE : GRAY_L, 1800),
            dataCell([para([boldColored(row[4], TEAL, { size: 18 })])], i % 2 === 0 ? WHITE : GRAY_L, 2200),
          ]})),
        ],
      }),
      space(160, 0),

      new Paragraph({ children: [new PageBreak()] }),

      // ════════════════════════════════════════
      // 5. PUZZLE PLAN
      // ════════════════════════════════════════
      ...sectionHeading('5. Puzzle Plan — 75 Puzzles for v1.0'),

      ...subHeading('5.1 Chapter Breakdown'),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [2340, 1560, 1560, 1560, 2340],
        rows: [
          new TableRow({ children: [
            headerCell('Chapter', PURPLE, WHITE, 2340),
            headerCell('Levels', PURPLE, WHITE, 1560),
            headerCell('Count', PURPLE, WHITE, 1560),
            headerCell('Difficulty', PURPLE, WHITE, 1560),
            headerCell('Expected Hint Usage', PURPLE, WHITE, 2340),
          ]}),
          new TableRow({ children: [
            dataCell([para([boldColored('Easy Warm-up', TEAL, { size: 18 })])], TEAL_L, 2340, allBorders(TEAL, 2)),
            dataCell('1–25', TEAL_L, 1560, allBorders(TEAL, 2)),
            dataCell('25', TEAL_L, 1560, allBorders(TEAL, 2)),
            dataCell('Simple logic, 1-step', TEAL_L, 1560, allBorders(TEAL, 2)),
            dataCell('Low — builds confidence', TEAL_L, 2340, allBorders(TEAL, 2)),
          ]}),
          new TableRow({ children: [
            dataCell([para([boldColored('Getting Tricky', AMBER, { size: 18 })])], AMBER_L, 2340, allBorders(AMBER, 2)),
            dataCell('26–50', AMBER_L, 1560, allBorders(AMBER, 2)),
            dataCell('25', AMBER_L, 1560, allBorders(AMBER, 2)),
            dataCell('Wordplay, visual tricks', AMBER_L, 1560, allBorders(AMBER, 2)),
            dataCell('Medium — ad revenue sweet spot', AMBER_L, 2340, allBorders(AMBER, 2)),
          ]}),
          new TableRow({ children: [
            dataCell([para([boldColored('Mind Benders', RED, { size: 18 })])], RED_L, 2340, allBorders(RED, 2)),
            dataCell('51–75', RED_L, 1560, allBorders(RED, 2)),
            dataCell('25', RED_L, 1560, allBorders(RED, 2)),
            dataCell('Lateral thinking', RED_L, 1560, allBorders(RED, 2)),
            dataCell('High — players buy hint coins here', RED_L, 2340, allBorders(RED, 2)),
          ]}),
        ],
      }),
      space(120, 0),

      ...subHeading('5.2 Puzzle Type Distribution'),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [3360, 1200, 4800],
        rows: [
          new TableRow({ children: [
            headerCell('Puzzle Type', PURPLE, WHITE, 3360),
            headerCell('Count', PURPLE, WHITE, 1200),
            headerCell('Description', PURPLE, WHITE, 4800),
          ]}),
          ...[
            ['MultiChoicePuzzle', '35', 'Four option buttons. Easiest to build. Most puzzles are this type.'],
            ['TapTargetPuzzle', '15', 'Tap a specific element on screen (find the odd one, tap the hidden object).'],
            ['DragDropPuzzle', '10', 'Drag an item to the correct position or drop zone.'],
            ['TypeAnswerPuzzle', '10', 'Player types exact answer using keyboard. Case-insensitive match.'],
            ['VisualTrickPuzzle', '5', 'The answer is tapping something unexpected — these go viral on social media!'],
          ].map((row, i) => new TableRow({ children: [
            dataCell([para([boldColored(row[0], PURPLE_D, { size: 18 })])], i % 2 === 0 ? WHITE : GRAY_L, 3360),
            dataCell([para([boldColored(row[1], PURPLE, { size: 18 })])], i % 2 === 0 ? WHITE : GRAY_L, 1200),
            dataCell(row[2], i % 2 === 0 ? WHITE : GRAY_L, 4800),
          ]})),
        ],
      }),
      space(120, 0),

      ...subHeading('5.3 All 25 Easy Puzzles (Week 1–2)'),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [560, 1200, 3600, 4000],
        rows: [
          new TableRow({ children: [
            headerCell('#', PURPLE, WHITE, 560),
            headerCell('Type', PURPLE, WHITE, 1200),
            headerCell('Question', PURPLE, WHITE, 3600),
            headerCell('Answer / Hint', PURPLE, WHITE, 4000),
          ]}),
          ...[
            ['1','MultiChoice','Which month has 28 days?','ALL months — every month has at least 28 days!'],
            ['2','MultiChoice','How many holes does a straw have?','1 — it\'s one continuous tunnel from top to bottom'],
            ['3','MultiChoice','You have 3 apples, take 2. How many do YOU have?','2 — you took them, so YOU have 2'],
            ['4','TypeAnswer','What do you call a fish without eyes?','FSH — remove the \'i\' (eye) from fish!'],
            ['5','MultiChoice','A rooster lays an egg on a barn. Which way does it roll?','Roosters don\'t lay eggs — only hens do'],
            ['6','MultiChoice','What is always in front of you but can\'t be seen?','The future — you can never see what hasn\'t happened'],
            ['7','MultiChoice','Man on 10th floor, takes elevator to 7th, walks up. Why?','He is too short to reach the button for floor 10'],
            ['8','TypeAnswer','What word becomes shorter when you add 2 letters?','SHORT — add \'er\' to make \'shorter\'!'],
            ['9','MultiChoice','What has hands but can\'t clap?','A clock — clock hands!'],
            ['10','MultiChoice','How far can a dog run into the forest?','Halfway — after that it runs OUT of the forest'],
            ['11','MultiChoice','What is full of holes but still holds water?','A sponge — it absorbs water despite the holes'],
            ['12','TypeAnswer','I have cities but no houses, mountains but no trees. What am I?','A map'],
            ['13','MultiChoice','What gets wetter the more it dries?','A towel — the more it dries things, the wetter it gets'],
            ['14','MultiChoice','Electric train heads north. Which way does smoke blow?','No smoke — electric trains produce no smoke!'],
            ['15','MultiChoice','What can you catch but not throw?','A cold — you catch it from someone sneezing'],
            ['16','TypeAnswer','What has a head, a tail, but no body?','A coin — heads and tails!'],
            ['17','MultiChoice','How many seconds are in a year?','12 — January 2nd, February 2nd... count the 2nds'],
            ['18','MultiChoice','What has teeth but cannot bite?','A comb — you run it through your hair'],
            ['19','TypeAnswer','David\'s father has 3 sons: Snap, Crackle, and ___?','David — the question tells you the third son\'s name'],
            ['20','MultiChoice','What is always coming but never arrives?','Tomorrow — when it arrives it becomes today'],
            ['21','MultiChoice','What is broken the moment you speak it?','Silence — making a sound breaks silence'],
            ['22','TypeAnswer','What building has the most stories?','Library — stories means books!'],
            ['23','MultiChoice','What goes up but never comes down?','Your age — it increases every birthday'],
            ['24','MultiChoice','What has an eye but cannot see?','A needle — the eye is the hole you thread'],
            ['25','VisualTrick','Tap the word that is RED.','Tap the word \'RED\' in the question — the color of the word, not what it says!'],
          ].map((row, i) => new TableRow({ children: [
            dataCell(row[0], i % 2 === 0 ? WHITE : GRAY_L, 560),
            dataCell(row[1], i % 2 === 0 ? WHITE : GRAY_L, 1200),
            dataCell(row[2], i % 2 === 0 ? WHITE : GRAY_L, 3600),
            dataCell(row[3], i % 2 === 0 ? WHITE : GRAY_L, 4000),
          ]})),
        ],
      }),
      space(80, 0),
      infoBox('NOTE', 'Medium (levels 26–50) and Hard (levels 51–75) puzzles are written in Week 5 when all screens are complete. This lets you test difficulty progression with real players during internal testing.', AMBER_L, AMBER),
      space(160, 0),

      new Paragraph({ children: [new PageBreak()] }),

      // ════════════════════════════════════════
      // 6. DATA STORAGE
      // ════════════════════════════════════════
      ...sectionHeading('6. Data Storage — SharedPreferences'),

      para([run('No database is needed. All game data is stored using SharedPreferences — a simple key-value store on the device. Works 100% offline. Data persists across app restarts.', { size: 20, color: GRAY_D })], { spacing: { after: 120 } }),

      ...subHeading('6.1 What Gets Stored'),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [2600, 1560, 2000, 3200],
        rows: [
          new TableRow({ children: [
            headerCell('Key', PURPLE, WHITE, 2600),
            headerCell('Type', PURPLE, WHITE, 1560),
            headerCell('Default', PURPLE, WHITE, 2000),
            headerCell('When Updated', PURPLE, WHITE, 3200),
          ]}),
          ...[
            ['completed_levels', 'int', '0', 'After each level is solved'],
            ['coins', 'int', '50', 'After earning (correct answer), spending (hint), watching rewarded ad'],
            ['total_score', 'int', '0', 'After each correct answer (+100 base points)'],
            ['total_games', 'int', '0', 'Incremented each time player starts a new level'],
            ['stars_0 … stars_74', 'int (1-3)', '0', 'After completing a level (3=no hints, 2=1 hint, 1=2+ hints)'],
            ['sound_enabled', 'bool', 'true', 'When player toggles in Settings'],
            ['music_enabled', 'bool', 'true', 'When player toggles in Settings'],
            ['vibration_enabled', 'bool', 'true', 'When player toggles in Settings'],
            ['session_count', 'int', '0', 'Incremented every time the app is opened (used for rate-us prompt after session 5)'],
          ].map((row, i) => new TableRow({ children: row.map((text, j) =>
            dataCell(text, i % 2 === 0 ? WHITE : GRAY_L, [2600, 1560, 2000, 3200][j])
          )})),
        ],
      }),
      space(120, 0),

      ...subHeading('6.2 Key Code — game_storage.dart'),
      codeBlock([
        'class GameStorage {',
        '  static SharedPreferences? _prefs;',
        '',
        '  static Future<void> init() async {',
        '    _prefs = await SharedPreferences.getInstance();',
        '    if (!_prefs!.containsKey("coins")) {',
        '      await _prefs!.setInt("coins", 50); // starter coins',
        '    }',
        '    await _prefs!.setInt("session_count", getSessionCount() + 1);',
        '  }',
        '',
        '  static int  getCompletedLevels()    => _prefs!.getInt("completed_levels") ?? 0;',
        '  static bool isLevelUnlocked(int i)  => i == 0 || i <= getCompletedLevels();',
        '  static int  getCoins()              => _prefs!.getInt("coins") ?? 50;',
        '  static int  getLevelStars(int i)    => _prefs!.getInt("stars_$i") ?? 0;',
        '',
        '  static Future<void> completeLevel(int i) async {',
        '    if (i + 1 > getCompletedLevels())',
        '      await _prefs!.setInt("completed_levels", i + 1);',
        '  }',
        '',
        '  static Future<bool> spendCoins(int amount) async {',
        '    if (getCoins() < amount) return false;',
        '    await _prefs!.setInt("coins", getCoins() - amount);',
        '    return true;',
        '  }',
        '',
        '  static int calculateStars(int hintsUsed) {',
        '    if (hintsUsed == 0) return 3;',
        '    if (hintsUsed == 1) return 2;',
        '    return 1;',
        '  }',
        '}',
      ]),
      space(160, 0),

      new Paragraph({ children: [new PageBreak()] }),

      // ════════════════════════════════════════
      // 7. ADMOB
      // ════════════════════════════════════════
      ...sectionHeading('7. AdMob Integration'),

      ...subHeading('7.1 Ad Placement Strategy'),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [1800, 2000, 2560, 3000],
        rows: [
          new TableRow({ children: [
            headerCell('Ad Type', PURPLE, WHITE, 1800),
            headerCell('Where', PURPLE, WHITE, 2000),
            headerCell('Trigger', PURPLE, WHITE, 2560),
            headerCell('User Experience', PURPLE, WHITE, 3000),
          ]}),
          ...[
            ['Banner', 'Home + Game screen bottom', 'Always visible', 'Non-intrusive. Never blocks gameplay.'],
            ['Interstitial', 'Result overlay', 'Every 3 completed levels', 'Skippable after 5 seconds. Feels natural between levels.'],
            ['Rewarded Video', 'Hint button + Result overlay', 'Player chooses to watch', 'Player gets 30 coins. Highest revenue because user opts in.'],
          ].map((row, i) => new TableRow({ children: row.map((text, j) =>
            dataCell(text, i % 2 === 0 ? WHITE : GRAY_L, [1800, 2000, 2560, 3000][j])
          )})),
        ],
      }),
      space(120, 0),

      ...subHeading('7.2 AndroidManifest.xml — Required'),
      codeBlock([
        '<!-- Add inside <application> tag -->',
        '<meta-data',
        '    android:name="com.google.android.gms.ads.APPLICATION_ID"',
        '    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>',
        '',
        '<!-- Add to <manifest> tag (internet permission) -->',
        '<uses-permission android:name="android.permission.INTERNET"/>',
      ]),
      space(80, 0),
      infoBox('IMPORTANT', 'Use test ad unit IDs during development. Only replace with real AdMob IDs in the final production build before uploading to Play Store. Using real IDs during testing violates AdMob policy.', RED_L, RED, GRAY_D),
      space(80, 0),

      ...subHeading('7.3 Test Ad Unit IDs (Use During Development)'),
      codeBlock([
        '// Banner',
        'ca-app-pub-3940256099942544/6300978111',
        '',
        '// Interstitial',
        'ca-app-pub-3940256099942544/1033173712',
        '',
        '// Rewarded Video',
        'ca-app-pub-3940256099942544/5224354917',
      ]),
      space(120, 0),

      ...subHeading('7.4 ad_manager.dart — Key Code'),
      codeBlock([
        'class AdManager {',
        '  static InterstitialAd? _interstitialAd;',
        '  static RewardedAd?     _rewardedAd;',
        '  static BannerAd?       bannerAd;',
        '',
        '  static Future<void> initialize() async {',
        '    await MobileAds.instance.initialize();',
        '    _loadInterstitial();',
        '    _loadRewarded();',
        '    _loadBanner();',
        '  }',
        '',
        '  static void showInterstitial({VoidCallback? onDismissed}) {',
        '    _interstitialAd?.fullScreenContentCallback =',
        '      FullScreenContentCallback(',
        '        onAdDismissedFullScreenContent: (_) {',
        '          _interstitialAd = null;',
        '          _loadInterstitial(); // preload next',
        '          onDismissed?.call();',
        '        },',
        '      );',
        '    _interstitialAd?.show();',
        '  }',
        '',
        '  static void showRewarded({required Function(int) onRewarded}) {',
        '    _rewardedAd?.show(',
        '      onUserEarnedReward: (_, reward) =>',
        '        onRewarded(reward.amount.toInt()),',
        '    );',
        '    _rewardedAd = null;',
        '    _loadRewarded(); // preload next',
        '  }',
        '}',
      ]),
      space(160, 0),

      new Paragraph({ children: [new PageBreak()] }),

      // ════════════════════════════════════════
      // 8. BUILD TIMELINE
      // ════════════════════════════════════════
      ...sectionHeading('8. Build Timeline — 8 Weeks to Launch'),

      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [1400, 2200, 3560, 2200],
        rows: [
          new TableRow({ children: [
            headerCell('Week', PURPLE, WHITE, 1400),
            headerCell('Phase', PURPLE, WHITE, 2200),
            headerCell('Tasks', PURPLE, WHITE, 3560),
            headerCell('Deliverable', PURPLE, WHITE, 2200),
          ]}),
          ...[
            ['Week 1–2', 'Setup + Core Engine', 'Flutter project, folder structure, AppTheme, Puzzle model, GameStorage (SharedPrefs), main.dart wired, 25 Easy puzzles written in PuzzleRepository', '25 puzzles + storage working'],
            ['Week 3–4', 'All 6 Screens Built', 'Splash, Home, Level Select, Game, Result Overlay, Settings. Full navigation wired. UI complete with puzzle widgets for all 5 types.', 'Complete app flow end-to-end'],
            ['Week 5', 'Puzzles + AdMob', 'Write 25 Medium puzzles (levels 26–50) and 25 Hard puzzles (levels 51–75). Integrate AdMob banner, interstitial, rewarded. Test with test IDs.', '75 puzzles + ads working'],
            ['Week 6', 'Polish + Sound', 'Lottie win/lose animations, button sounds (audioplayers), correct/wrong feedback animations (flutter_animate), hint animation. Full bug testing.', 'Production-quality feel'],
            ['Week 7–8', 'Play Store Launch', 'App icon (512x512), 8 screenshots, store listing text, privacy policy URL, replace test ad IDs with real AdMob IDs, submit for review.', 'App live on Play Store!'],
          ].map((row, i) => {
            const colors = ['059669', AMBER, RED, '185FA5', PURPLE_D];
            const bgs = [TEAL_L, AMBER_L, RED_L, 'EFF6FF', PURPLE_L];
            return new TableRow({ children: [
              dataCell([para([boldColored(row[0], WHITE, { size: 18 })])], colors[i], 1400, allBorders(colors[i], 2)),
              dataCell([para([boldColored(row[1], colors[i], { size: 18 })])], bgs[i], 2200, allBorders(colors[i], 2)),
              dataCell(row[2], bgs[i], 3560, allBorders(colors[i], 2)),
              dataCell([para([boldColored(row[3], colors[i], { size: 18 })])], bgs[i], 2200, allBorders(colors[i], 2)),
            ]});
          }),
        ],
      }),
      space(160, 0),

      new Paragraph({ children: [new PageBreak()] }),

      // ════════════════════════════════════════
      // 9. ANDROID SETUP
      // ════════════════════════════════════════
      ...sectionHeading('9. Android Setup (Ubuntu)'),

      ...subHeading('9.1 Flutter Doctor Status'),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [600, 2760, 6000],
        rows: [
          new TableRow({ children: [
            headerCell('', PURPLE, WHITE, 600),
            headerCell('Check', PURPLE, WHITE, 2760),
            headerCell('Status', PURPLE, WHITE, 6000),
          ]}),
          ...[
            ['✓', 'Flutter (Channel stable, 3.29.2)', 'Installed on Ubuntu 22.04 LTS'],
            ['✓', 'Chrome', 'Available for web development'],
            ['✓', 'Linux toolchain', 'Available for Linux desktop'],
            ['✓', 'VS Code 1.113+', 'Installed with Flutter extension'],
            ['✗', 'Android toolchain', 'Needs Android Studio + SDK installation'],
            ['✗', 'Android Studio', 'Not yet installed — follow Section 9.2'],
          ].map((row, i) => new TableRow({ children: [
            dataCell([para([boldColored(row[0], row[0] === '✓' ? TEAL : RED, { size: 20 })])], i % 2 === 0 ? WHITE : GRAY_L, 600),
            dataCell(row[1], i % 2 === 0 ? WHITE : GRAY_L, 2760),
            dataCell(row[2], i % 2 === 0 ? WHITE : GRAY_L, 6000),
          ]})),
        ],
      }),
      space(120, 0),

      ...subHeading('9.2 Android Studio Installation Steps'),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [600, 8760],
        rows: [
          ...[
            ['1', 'Download Android Studio from https://developer.android.com/studio (Linux .tar.gz)'],
            ['2', 'Install: sudo tar -xzf android-studio-*.tar.gz -C /opt/'],
            ['3', 'Launch: sudo /opt/android-studio/bin/studio.sh — choose "Standard" setup'],
            ['4', 'Let the wizard download Android SDK (takes 10–15 min)'],
            ['5', 'Add to ~/.bashrc:\n      export ANDROID_HOME=$HOME/Android/Sdk\n      export PATH=$PATH:$ANDROID_HOME/tools\n      export PATH=$PATH:$ANDROID_HOME/platform-tools'],
            ['6', 'Apply: source ~/.bashrc'],
            ['7', 'Tell Flutter: flutter config --android-sdk $HOME/Android/Sdk'],
            ['8', 'Accept licenses: flutter doctor --android-licenses (type y for each)'],
            ['9', 'Run: flutter doctor — should now show all green ticks'],
          ].map((row, i) => new TableRow({ children: [
            new TableCell({
              children: [para([boldColored(row[0], WHITE, { size: 18 })])],
              shading: { fill: PURPLE, type: ShadingType.CLEAR },
              borders: allBorders(PURPLE, 2),
              margins: { top: 100, bottom: 100, left: 140, right: 140 },
              width: { size: 600, type: WidthType.DXA },
            }),
            dataCell(row[1], i % 2 === 0 ? WHITE : GRAY_L, 8760, allBorders(PURPLE_L, 2)),
          ]})),
        ],
      }),
      space(120, 0),

      ...subHeading('9.3 Connect Android Phone for Testing'),
      bullet('Go to Settings → About Phone → tap Build Number 7 times fast'),
      bullet('Go back to Settings → Developer Options → turn on USB Debugging'),
      bullet('Connect phone to PC via USB, tap Allow when prompted'),
      bullet('Run: flutter devices — your phone should appear in the list'),
      bullet('Run: flutter run — app will install and launch on your phone'),
      space(160, 0),

      new Paragraph({ children: [new PageBreak()] }),

      // ════════════════════════════════════════
      // 10. PLAY STORE CHECKLIST
      // ════════════════════════════════════════
      ...sectionHeading('10. Play Store Submission Checklist'),

      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [600, 3160, 5600],
        rows: [
          new TableRow({ children: [
            headerCell('', PURPLE, WHITE, 600),
            headerCell('Requirement', PURPLE, WHITE, 3160),
            headerCell('Detail', PURPLE, WHITE, 5600),
          ]}),
          ...[
            ['App icon', 'Design in Figma or Canva. 512×512 PNG. Purple brain theme recommended.'],
            ['8 screenshots', 'Show: Home screen, Level Select grid, Game screen (puzzle visible), Win screen with stars. Use phone size (1080×1920).'],
            ['Feature graphic', 'Optional but recommended. 1024×500 PNG. Shows in Play Store top banner.'],
            ['Privacy policy URL', 'REQUIRED. Use privacypolicygenerator.info (free). Host on GitHub Pages. Must mention AdMob and data collection.'],
            ['Short description', '80 characters max. Example: "80 tricky brain puzzles to test your IQ offline!"'],
            ['Full description', '4000 characters max. Include: game features, offline play, puzzle types, ad disclosure.'],
            ['Content rating', 'Complete IARC questionnaire in Play Console. Target rating: Everyone (3+).'],
            ['Target API level 34', 'Required by Google as of 2024. Set in android/app/build.gradle: targetSdkVersion 34'],
            ['AdMob App ID', 'Apply at admob.google.com BEFORE submitting. Takes 2–7 days to approve.'],
            ['Real ad unit IDs', 'Replace all test IDs with real AdMob unit IDs in final production build only.'],
            ['Developer fee', 'One-time $25 USD payment to Google. Paid once, covers all apps forever.'],
            ['App bundle (AAB)', 'Build with: flutter build appbundle. Upload the .aab file, not the .apk.'],
          ].map((row, i) => new TableRow({ children: [
            new TableCell({
              children: [para([boldColored('✓', TEAL, { size: 20 })])],
              shading: { fill: TEAL_L, type: ShadingType.CLEAR },
              borders: allBorders(TEAL, 2),
              margins: { top: 100, bottom: 100, left: 140, right: 140 },
              width: { size: 600, type: WidthType.DXA },
            }),
            dataCell([para([boldColored(row[0], PURPLE_D, { size: 18 })])], i % 2 === 0 ? WHITE : GRAY_L, 3160),
            dataCell(row[1], i % 2 === 0 ? WHITE : GRAY_L, 5600),
          ]})),
        ],
      }),
      space(160, 0),

      new Paragraph({ children: [new PageBreak()] }),

      // ════════════════════════════════════════
      // 11. REVENUE PROJECTION
      // ════════════════════════════════════════
      ...sectionHeading('11. Revenue Projection'),

      ...subHeading('11.1 Estimated Monthly Revenue (India)'),
      new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: [2200, 1800, 1800, 1760, 2000, 1800],
        rows: [
          new TableRow({ children: [
            headerCell('DAU (Daily Users)', PURPLE, WHITE, 2200),
            headerCell('Banner/day', PURPLE, WHITE, 1800),
            headerCell('Interstitial/day', PURPLE, WHITE, 1800),
            headerCell('Rewarded/day', PURPLE, WHITE, 1760),
            headerCell('Est. Daily Revenue', PURPLE, WHITE, 2000),
            headerCell('Est. Monthly', PURPLE, WHITE, 1800),
          ]}),
          ...[
            ['1,000', '₹50', '₹150', '₹100', '₹300', '₹9,000'],
            ['5,000', '₹250', '₹750', '₹500', '₹1,500', '₹45,000'],
            ['10,000', '₹500', '₹1,500', '₹1,000', '₹3,000', '₹90,000'],
            ['50,000', '₹2,500', '₹7,500', '₹5,000', '₹15,000', '₹4,50,000'],
          ].map((row, i) => new TableRow({ children: row.map((text, j) =>
            dataCell(
              j === 4 || j === 5 ? [para([boldColored(text, TEAL, { size: 18 })])] : text,
              i % 2 === 0 ? WHITE : GRAY_L,
              [2200, 1800, 1800, 1760, 2000, 1800][j]
            )
          )})),
        ],
      }),
      space(80, 0),
      infoBox('TIP', 'Rewarded ads drive the most revenue. Design hard levels that make players want hints — but keep hints optional so players never feel forced. A happy player who watches one rewarded ad per session is worth 10x a player who closes the app in frustration.', TEAL_L, TEAL, GRAY_D),
      space(80, 0),

      ...subHeading('11.2 Growth Strategy After Launch'),
      bullet('Push update with 25 new puzzles within 4 weeks of launch — this triggers the algorithm to re-show your app'),
      bullet('Reply to all Play Store reviews in the first month — increases ranking signals'),
      bullet('Add a "Share this puzzle" button on the result screen — brain puzzles are viral content'),
      bullet('Add daily challenge feature in version 1.1 — gives players a reason to open the app every day'),
      bullet('Add a Hindi language option — India\'s largest player segment is Hindi-speaking'),
      space(200, 0),

      // ════════════════════════════════════════
      // FOOTER
      // ════════════════════════════════════════
      new Paragraph({
        alignment: AlignmentType.CENTER,
        border: { top: border(PURPLE_L, 6) },
        spacing: { before: 200, after: 60 },
        children: [
          boldColored('Brain Twist — Flutter Game Project Document', PURPLE, { size: 18 }),
        ],
      }),
      new Paragraph({
        alignment: AlignmentType.CENTER,
        children: [run('v1.0 First Release  |  8-Week Build Plan  |  75 Puzzles  |  Google AdMob Monetization', { size: 16, color: GRAY_MID })],
      }),
    ],
}],
});

Packer.toBuffer(doc).then(buf => {
fs.writeFileSync('/mnt/user-data/outputs/BrainTwist_Project_Document.docx', buf);
console.log('Done!');
}).catch(e => { console.error(e); process.exit(1); });