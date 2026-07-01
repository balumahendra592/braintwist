import '../models/puzzle_model.dart';

class PuzzleRepository {
  static const List<Puzzle> puzzles = [

    // ═══════════════════════════════════════════════════════════
    // CHAPTER 1 — EASY WARM-UP  (levels 1–25)
    // 12 visual tricks + 13 other types
    // ═══════════════════════════════════════════════════════════

    // L1 — Maths — multiChoice
    Puzzle(
      id: 1, levelNumber: 1, chapter: 'easy',
      type: PuzzleType.multiChoice,
      question: "🔢 Solve this WITHOUT a calculator:\n1 + 1 + 1 + 1 × 0 = ?",
      options: ["0", "4", "3", "5"],
      correctOptionIndex: 2,
      hintText: "BODMAS: multiply first! 1×0=0, then 1+1+1+0 = 3.",
    ),

    // L2 — Visual — odd_smiley
    Puzzle(
      id: 2, levelNumber: 2, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "😊 One face is the odd one out.\nTap the emoji that looks DIFFERENT from all the others!",
      correctTargetId: 'odd_smiley',
      hintText: "Look at every face slowly. One has a very different expression!",
    ),

    // L3 — Tech — tapTarget
    Puzzle(
      id: 3, levelNumber: 3, chapter: 'easy',
      type: PuzzleType.tapTarget,
      question: "🧪 Tap the keyboard shortcut that UNDOES your last action",
      options: ["Ctrl+C", "Ctrl+V", "Ctrl+Z", "Ctrl+X"],
      correctTargetId: "Ctrl+Z",
      hintText: "Z for Zero mistakes — undo is every developer's best friend!",
    ),

    // L4 — Visual — blue_word
    Puzzle(
      id: 4, levelNumber: 4, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "🎨 Your brain wants to read the WORDS.\nFight it! Tap the word whose actual INK COLOR is BLUE.",
      correctTargetId: 'blue_word',
      hintText: "Ignore what the word says. Only look at the colour of the ink itself!",
    ),

    // L5 — History — multiChoice
    Puzzle(
      id: 5, levelNumber: 5, chapter: 'easy',
      type: PuzzleType.multiChoice,
      question: "📜 Who was the FIRST human to walk on the Moon?",
      options: ["Buzz Aldrin", "Yuri Gagarin", "Neil Armstrong", "Alan Shepard"],
      correctOptionIndex: 2,
      hintText: "July 20, 1969 — 'One small step for man…' Apollo 11.",
    ),

    // L6 — Visual — b_hidden
    Puzzle(
      id: 6, levelNumber: 6, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "🔍 The letter B is hiding among the 8s.\nFind it and tap it before time tricks you!",
      correctTargetId: 'b_hidden',
      hintText: "8 and B look similar — one rounded top, one rounded bottom. Find the two-bump one!",
    ),

    // L7 — Mythology — multiChoice
    Puzzle(
      id: 7, levelNumber: 7, chapter: 'easy',
      type: PuzzleType.multiChoice,
      question: "⚡ Zeus, Poseidon, and Hades divided the universe.\nHades got stuck with…",
      options: ["The sea 🌊", "The sky ⛅", "The earth 🌍", "The underworld 💀"],
      correctOptionIndex: 3,
      hintText: "He literally drew the short straw — ruling the dead for eternity!",
    ),

    // L8 — GK — typeAnswer
    Puzzle(
      id: 8, levelNumber: 8, chapter: 'easy',
      type: PuzzleType.typeAnswer,
      question: "🌍 What is the 2-letter chemical symbol for GOLD?\n(Hint: it comes from the Latin name)",
      correctAnswer: "au",
      hintText: "From Latin 'Aurum'. That's why it's Au — not Go!",
    ),

    // L9 — Visual — flip_6
    Puzzle(
      id: 9, levelNumber: 9, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "🔢 This digit is displayed UPSIDE DOWN.\nWhat number is REALLY shown here when flipped right-side up?",
      correctTargetId: 'flip_6',
      hintText: "Rotate your mental picture 180°. Which digit looks like the other when flipped?",
    ),

    // L10 — Problem Solving — multiChoice
    Puzzle(
      id: 10, levelNumber: 10, chapter: 'easy',
      type: PuzzleType.multiChoice,
      question: "🧩 A farmer has 17 sheep.\nAll BUT 9 die. How many sheep remain?",
      options: ["8", "0", "17", "9"],
      correctOptionIndex: 3,
      hintText: "'All but 9' means 9 SURVIVE. It's the wording that's tricky!",
    ),

    // L11 — Visual — c_hidden
    Puzzle(
      id: 11, levelNumber: 11, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "👁️ A sneaky C is hiding among these Os.\nCan you spot the imposter?",
      correctTargetId: 'c_hidden',
      hintText: "C and O look nearly identical. The C has a tiny gap on the right side!",
    ),

    // L12 — Maths — typeAnswer
    Puzzle(
      id: 12, levelNumber: 12, chapter: 'easy',
      type: PuzzleType.typeAnswer,
      question: "🔢 Multiply ALL the numbers on a phone keypad together.\n1×2×3×4×5×6×7×8×9×0 = ?",
      correctAnswer: "0",
      hintText: "There's a 0 on the keypad. Anything × 0 = 0. Always!",
    ),

    // L13 — Visual — mueller_same
    Puzzle(
      id: 13, levelNumber: 13, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "📏 Which horizontal line is LONGER — Line A or Line B?\nLook carefully before you answer!",
      correctTargetId: 'mueller_same',
      hintText: "The arrows at the ends are designed to fool you. Trust the ruler, not your eyes!",
    ),

    // L14 — Tech — tapTarget
    Puzzle(
      id: 14, levelNumber: 14, chapter: 'easy',
      type: PuzzleType.tapTarget,
      question: "🧪 Tap what 'AI' stands for in technology",
      options: ["Automated Internet", "Artificial Intelligence", "Android Interface", "Advanced Input"],
      correctTargetId: "Artificial Intelligence",
      hintText: "It powers face recognition, voice assistants, and content recommendations.",
    ),

    // L15 — Relationship — tapTarget
    Puzzle(
      id: 15, levelNumber: 15, chapter: 'easy',
      type: PuzzleType.tapTarget,
      question: "💑 Tap what matters MOST in any lasting relationship",
      options: ["Money 💰", "Trust 🤝", "Fame 🌟", "Looks 💄"],
      correctTargetId: "Trust 🤝",
      hintText: "Everything else crumbles without this foundation.",
    ),

    // L16 — Visual — nine_hidden
    Puzzle(
      id: 16, levelNumber: 16, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "🕵️ A 9 is disguised among all these 6s.\nSpot the imposter — but don't let them trick you!",
      correctTargetId: 'nine_hidden',
      hintText: "6 and 9 look like rotations of each other. Find the one with the tail at the TOP!",
    ),

    // L17 — Visual — odd_star
    Puzzle(
      id: 17, levelNumber: 17, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "⭐ Not all stars are created equal.\nOne star is DIFFERENT from the rest — tap it!",
      correctTargetId: 'odd_star',
      hintText: "Look at the fill colour of each star. One is an outline, the others are solid!",
    ),

    // L18 — History — multiChoice
    Puzzle(
      id: 18, levelNumber: 18, chapter: 'easy',
      type: PuzzleType.multiChoice,
      question: "📜 Cleopatra is famously associated with Egypt.\nBut what was her actual ancestry?",
      options: ["Egyptian — born in Alexandria", "Greek-Macedonian by descent", "Roman by blood", "Persian by origin"],
      correctOptionIndex: 1,
      hintText: "She descended from Ptolemy I, one of Alexander the Great's generals!",
    ),

    // L19 — Mythology — tapTarget
    Puzzle(
      id: 19, levelNumber: 19, chapter: 'easy',
      type: PuzzleType.tapTarget,
      question: "⚡ Tap the name of Thor's legendary hammer",
      options: ["Excalibur", "Gungnir", "Mjolnir", "Trident"],
      correctTargetId: "Mjolnir",
      hintText: "Only the worthy can lift it — and it comes back like a boomerang!",
    ),

    // L20 — Visual — ebbinghaus
    Puzzle(
      id: 20, levelNumber: 20, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "🟠 Compare ONLY the orange circles in the centre.\nWhich one looks bigger — A or B?",
      correctTargetId: 'ebbinghaus',
      hintText: "The surrounding circles influence your perception. Don't let them fool you!",
    ),

    // L21 — GK — multiChoice
    Puzzle(
      id: 21, levelNumber: 21, chapter: 'easy',
      type: PuzzleType.multiChoice,
      question: "🌍 Which planet has the most confirmed moons (as of 2023)?",
      options: ["Jupiter", "Uranus", "Saturn", "Neptune"],
      correctOptionIndex: 2,
      hintText: "Saturn overtook Jupiter in 2023 with 146 moons — rings AND moons!",
    ),

    // L22 — Visual — count_squares_6
    Puzzle(
      id: 22, levelNumber: 22, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "🔲 How many squares can you count in total?\n(Squares can overlap and combine!)",
      correctTargetId: 'count_squares_6',
      hintText: "Count individual squares PLUS combinations. Think beyond the obvious!",
    ),

    // L23 — Problem Solving — typeAnswer
    Puzzle(
      id: 23, levelNumber: 23, chapter: 'easy',
      type: PuzzleType.typeAnswer,
      question: "🧩 I'm always ahead of you but can NEVER be seen,\ntouched, or caught. What am I?",
      correctAnswer: "future",
      hintText: "When it arrives, it instantly becomes the present.",
    ),

    // L24 — Visual — flip_mom
    Puzzle(
      id: 24, levelNumber: 24, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "💡 This word is written UPSIDE DOWN.\nFlip it right-side up in your head — what does it really say?",
      correctTargetId: 'flip_mom',
      hintText: "W upside down = M. O upside down = O. Three letters, one beautiful trick!",
    ),

    // L25 — Visual — red_word
    Puzzle(
      id: 25, levelNumber: 25, chapter: 'easy',
      type: PuzzleType.visualTrick,
      question: "🎨 Your reading brain will fight you on this one.\nTap the word whose actual INK COLOR is RED.",
      correctTargetId: 'red_word',
      hintText: "Ignore what the word SAYS. Look only at the colour of the ink itself!",
    ),

    // ═══════════════════════════════════════════════════════════
    // CHAPTER 2 — GETTING TRICKY  (levels 26–50)
    // 12 visual tricks + 13 other types
    // ═══════════════════════════════════════════════════════════

    // L26 — Visual — count_triangles_5
    Puzzle(
      id: 26, levelNumber: 26, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "🔺 Count ALL the triangles in this figure — big AND small!\nDon't forget the ones formed by combining smaller ones.",
      correctTargetId: 'count_triangles_5',
      hintText: "Look for triangles inside triangles! The big outer one counts too.",
    ),

    // L27 — Maths — multiChoice
    Puzzle(
      id: 27, levelNumber: 27, chapter: 'medium',
      type: PuzzleType.multiChoice,
      question: "🔢 What comes NEXT in this sequence?\n2, 3, 5, 8, 13, ?",
      options: ["19", "18", "21", "20"],
      correctOptionIndex: 2,
      hintText: "Each number is the sum of the two before it. This is the Fibonacci sequence!",
    ),

    // L28 — Visual — green_word
    Puzzle(
      id: 28, levelNumber: 28, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "🎨 Challenge: your brain AUTO-READS words.\nFight it — tap the word whose INK is coloured GREEN.",
      correctTargetId: 'green_word',
      hintText: "The word 'GREEN' might NOT be the green-coloured one. Focus on ink!",
    ),

    // L29 — Tech — multiChoice
    Puzzle(
      id: 29, levelNumber: 29, chapter: 'medium',
      type: PuzzleType.multiChoice,
      question: "🧪 Before becoming Google, Larry Page & Sergey Brin named their search engine…",
      options: ["Googol", "PageRank", "WebSearch", "BackRub"],
      correctOptionIndex: 3,
      hintText: "They built it to analyse back-links — 'back-rubbing' the web. Seriously.",
    ),

    // L30 — Visual — odd_triangle
    Puzzle(
      id: 30, levelNumber: 30, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "🔺 One triangle in the group is pointing the WRONG way.\nFind the odd one out and tap it!",
      correctTargetId: 'odd_triangle',
      hintText: "Most triangles point one way. The imposter points the OTHER direction!",
    ),

    // L31 — History — multiChoice
    Puzzle(
      id: 31, levelNumber: 31, chapter: 'medium',
      type: PuzzleType.multiChoice,
      question: "📜 The Titanic struck an iceberg and sank in which year?",
      options: ["1905", "1920", "1918", "1912"],
      correctOptionIndex: 3,
      hintText: "April 14–15, 1912 — its maiden voyage to New York. Never arrived.",
    ),

    // L32 — Visual — p_hidden
    Puzzle(
      id: 32, levelNumber: 32, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "🔍 A lone P is hiding among all these Fs.\nFind it — P and F are sneaky neighbours!",
      correctTargetId: 'p_hidden',
      hintText: "F has two horizontal lines. P has a bump on the right. One tile has that bump!",
    ),

    // L33 — Mythology — multiChoice
    Puzzle(
      id: 33, levelNumber: 33, chapter: 'medium',
      type: PuzzleType.multiChoice,
      question: "⚡ In Hindu mythology, who is the DESTROYER in the Holy Trinity?",
      options: ["Brahma", "Vishnu", "Indra", "Shiva"],
      correctOptionIndex: 3,
      hintText: "He destroys the universe only to recreate it — and performs the cosmic Tandav dance!",
    ),

    // L34 — Visual — count_dots_7
    Puzzle(
      id: 34, levelNumber: 34, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "⚪ Count all the white dots in the pattern carefully.\nHow many are there in total?",
      correctTargetId: 'count_dots_7',
      hintText: "Count row by row from top to bottom. Don't rush!",
    ),

    // L35 — GK — tapTarget
    Puzzle(
      id: 35, levelNumber: 35, chapter: 'medium',
      type: PuzzleType.tapTarget,
      question: "🌍 Tap the one that is NOT a planet in our solar system",
      options: ["Neptune", "Pluto", "Uranus", "Venus"],
      correctTargetId: "Pluto",
      hintText: "Poor Pluto was demoted to 'dwarf planet' status in 2006. 😢",
    ),

    // L36 — Problem Solving — multiChoice
    Puzzle(
      id: 36, levelNumber: 36, chapter: 'medium',
      type: PuzzleType.multiChoice,
      question: "🧩 You are in a race.\nYou overtake the person in 2nd place.\nWhat position are you in now?",
      options: ["1st 🥇", "2nd 🥈", "3rd 🥉", "Last"],
      correctOptionIndex: 1,
      hintText: "You took THEIR position — you're now 2nd. You never passed 1st place!",
    ),

    // L37 — Visual — yellow_word
    Puzzle(
      id: 37, levelNumber: 37, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "🎨 Stroop challenge level 4!\nTap the word that is actually printed in YELLOW ink.",
      correctTargetId: 'yellow_word',
      hintText: "The word 'YELLOW' might be printed in a completely different colour. Check the ink!",
    ),

    // L38 — Problem Solving — typeAnswer
    Puzzle(
      id: 38, levelNumber: 38, chapter: 'medium',
      type: PuzzleType.typeAnswer,
      question: "🧩 Add the letter S to the front of the word LAUGHTER.\nWhat terrifying word do you get?",
      correctAnswer: "slaughter",
      hintText: "One letter completely flips the meaning. Language is wild.",
    ),

    // L39 — Tech — tapTarget
    Puzzle(
      id: 39, levelNumber: 39, chapter: 'medium',
      type: PuzzleType.tapTarget,
      question: "🧪 Tap the programming language named after a coffee-producing island in Indonesia",
      options: ["Python", "Ruby", "Swift", "Java"],
      correctTargetId: "Java",
      hintText: "Developers were fuelled by coffee from the island of Java. The name stuck!",
    ),

    // L40 — Visual — eight_holes
    Puzzle(
      id: 40, levelNumber: 40, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "👕 A T-shirt is laid flat in front of you.\nCount EVERY hole — including front-to-back openings.\nHow many holes does it have?",
      correctTargetId: 'eight_holes',
      hintText: "Each opening (neck, arms, bottom) goes through BOTH the front AND back layer!",
    ),

    // L41 — Relationship — dragDrop
    Puzzle(
      id: 41, levelNumber: 41, chapter: 'medium',
      type: PuzzleType.dragDrop,
      question: "💑 Your partner says 'Do whatever you want.'\nDrag what you should ACTUALLY do.",
      dragItemLabel: "Nothing — it's a trap 🪤",
      dropZoneLabel: "The safe choice is...",
      hintText: "Experience is the best teacher here. Heed the warning. 😅",
    ),

    // L42 — Visual — odd_moon
    Puzzle(
      id: 42, levelNumber: 42, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "🌙 The night sky has an imposter!\nOne item does NOT belong among the moons — tap it!",
      correctTargetId: 'odd_moon',
      hintText: "All the moons look the same — until you spot the one that shines differently!",
    ),

    // L43 — History — multiChoice
    Puzzle(
      id: 43, levelNumber: 43, chapter: 'medium',
      type: PuzzleType.multiChoice,
      question: "📜 In what year did the Berlin Wall finally fall?",
      options: ["1985", "1993", "1991", "1989"],
      correctOptionIndex: 3,
      hintText: "November 9, 1989 — one of the most dramatic nights in Cold War history.",
    ),

    // L44 — Visual — flip_6
    Puzzle(
      id: 44, levelNumber: 44, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "🔢 This digit looks different from what it really is.\nWhat number do you see when you flip it RIGHT-SIDE UP?",
      correctTargetId: 'flip_6',
      hintText: "Some digits become other digits when rotated 180°. Which pair does this?",
    ),

    // L45 — Relationship — tapTarget
    Puzzle(
      id: 45, levelNumber: 45, chapter: 'medium',
      type: PuzzleType.tapTarget,
      question: "💑 In any argument with someone you love,\ntap what you should do FIRST",
      options: ["Apologize 🙏", "Win 🏆", "Listen 👂", "Ignore it 🚪"],
      correctTargetId: "Listen 👂",
      hintText: "You can't solve a problem you haven't fully heard. Ego kills relationships.",
    ),

    // L46 — Mythology — multiChoice
    Puzzle(
      id: 46, levelNumber: 46, chapter: 'medium',
      type: PuzzleType.multiChoice,
      question: "⚡ Medusa could turn anyone to stone with her…",
      options: ["Touch 🤚", "Breath 💨", "Voice 🗣️", "Gaze 👁️"],
      correctOptionIndex: 3,
      hintText: "Perseus used a polished shield as a mirror to avoid looking directly at her.",
    ),

    // L47 — Visual — count_f
    Puzzle(
      id: 47, levelNumber: 47, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "🔤 READ the passage below and count EVERY capital letter F.\nMost people get this wrong!",
      correctTargetId: 'count_f',
      hintText: "Read very slowly. Your brain skips the Fs in small words like 'OF' because it sounds like 'ov'!",
    ),

    // L48 — Visual — mueller_same
    Puzzle(
      id: 48, levelNumber: 48, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "📏 Classic optical illusion!\nLine A and Line B — which one is actually LONGER?",
      correctTargetId: 'mueller_same',
      hintText: "The arrowheads at the ends create a powerful visual illusion. Measure with your finger!",
    ),

    // L49 — Problem Solving — multiChoice
    Puzzle(
      id: 49, levelNumber: 49, chapter: 'medium',
      type: PuzzleType.multiChoice,
      question: "🧩 You have 10 socks in a dark drawer: 5 red and 5 blue.\nHow many must you pull out to GUARANTEE a matching pair?",
      options: ["2", "5", "10", "3"],
      correctOptionIndex: 3,
      hintText: "Worst case: 1 red + 1 blue. The 3rd sock MUST match one of them!",
    ),

    // L50 — Visual — eight_hidden
    Puzzle(
      id: 50, levelNumber: 50, chapter: 'medium',
      type: PuzzleType.visualTrick,
      question: "🔍 The number 8 is hiding among these characters.\nFind it and tap it before your eyes give up!",
      correctTargetId: 'eight_hidden',
      hintText: "8 has TWO closed loops, one on top and one on the bottom. Look for double loops!",
    ),

    // ═══════════════════════════════════════════════════════════
    // CHAPTER 3 — MIND BENDERS  (levels 51–75)
    // 12 visual tricks + 13 other types
    // ═══════════════════════════════════════════════════════════

    // L51 — Visual — ebbinghaus
    Puzzle(
      id: 51, levelNumber: 51, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "🟠 The Ebbinghaus illusion returns!\nAre the two orange circles in the centres actually the same size?",
      correctTargetId: 'ebbinghaus',
      hintText: "Context fools perception every time. The surrounding circles change what you think you see!",
    ),

    // L52 — GK — typeAnswer
    Puzzle(
      id: 52, levelNumber: 52, chapter: 'hard',
      type: PuzzleType.typeAnswer,
      question: "🌍 What is the ONLY country that is ALSO a continent?\n(one word)",
      correctAnswer: "australia",
      hintText: "It's both the smallest continent AND the only country occupying an entire one.",
    ),

    // L53 — Visual — blue_word
    Puzzle(
      id: 53, levelNumber: 53, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "🎨 Expert Stroop! Your brain is faster than you think.\nTap ONLY the word whose actual ink is BLUE.",
      correctTargetId: 'blue_word',
      hintText: "The word 'BLUE' might be written in red, green, or yellow. Only the INK colour matters!",
    ),

    // L54 — Maths — multiChoice
    Puzzle(
      id: 54, levelNumber: 54, chapter: 'hard',
      type: PuzzleType.multiChoice,
      question: "🔢 If you fold a paper in half 42 times,\nhow thick would it be?",
      options: ["As tall as a skyscraper", "Thicker than Earth to Moon 🌕", "About 1 km thick", "A mattress-sized stack"],
      correctOptionIndex: 1,
      hintText: "2^42 × 0.1mm ≈ 439,804 km. The Moon is ~384,400 km away. Exponential = insane!",
    ),

    // L55 — Visual — odd_smiley
    Puzzle(
      id: 55, levelNumber: 55, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "😊 They almost all look the same — almost.\nFind the ONE face that is slightly different and tap it!",
      correctTargetId: 'odd_smiley',
      hintText: "Look at the shape of each mouth carefully. One face is surprised, not smiling!",
    ),

    // L56 — Tech — multiChoice
    Puzzle(
      id: 56, levelNumber: 56, chapter: 'hard',
      type: PuzzleType.multiChoice,
      question: "🧪 Facebook was originally launched under a different name.\nWhat was it?",
      options: ["FaceMash", "ConnectU", "TheFacebook", "HarvardNet"],
      correctOptionIndex: 2,
      hintText: "Mark Zuckerberg launched 'TheFacebook' in February 2004 for Harvard students only.",
    ),

    // L57 — Visual — b_hidden
    Puzzle(
      id: 57, levelNumber: 57, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "🔍 A stealthy B is hiding in a crowd of 8s.\nYour eyes will try to skip it — don't let them!",
      correctTargetId: 'b_hidden',
      hintText: "B has two bumps on the RIGHT side. 8 has equal bumps top and bottom. Spot the asymmetry!",
    ),

    // L58 — History — multiChoice
    Puzzle(
      id: 58, levelNumber: 58, chapter: 'hard',
      type: PuzzleType.multiChoice,
      question: "📜 The shortest war in history (1896) lasted approximately…",
      options: ["6 hours", "2 hours", "1 day", "38 minutes"],
      correctOptionIndex: 3,
      hintText: "The Anglo-Zanzibar War — Zanzibar's navy was sunk before most soldiers finished breakfast!",
    ),

    // L59 — Visual — count_triangles_5
    Puzzle(
      id: 59, levelNumber: 59, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "🔺 This triangle hides more triangles inside.\nCount EVERY one you can find — big AND small!",
      correctTargetId: 'count_triangles_5',
      hintText: "4 inner triangles + the 1 large outer triangle = total. Did you forget the big one?",
    ),

    // L60 — Maths — typeAnswer
    Puzzle(
      id: 60, levelNumber: 60, chapter: 'hard',
      type: PuzzleType.typeAnswer,
      question: "🔢 What is the SUM of all whole numbers from 1 to 100?\n(No calculator — use the pattern!)",
      correctAnswer: "5050",
      hintText: "Gauss did this as a child: pair 1+100, 2+99... = 50 pairs × 101 = 5050!",
    ),

    // L61 — Visual — nine_hidden
    Puzzle(
      id: 61, levelNumber: 61, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "🕵️ A single 9 has infiltrated a crowd of 6s.\nYour brain will try to blend them — fight it!",
      correctTargetId: 'nine_hidden',
      hintText: "A 6 has its tail at the bottom. A 9 has its tail at the TOP. Find the top-tail one!",
    ),

    // L62 — Tech — multiChoice
    Puzzle(
      id: 62, levelNumber: 62, chapter: 'hard',
      type: PuzzleType.multiChoice,
      question: "🧪 What does 'RAM' stand for in computing?",
      options: ["Read All Memory", "Rapid Access Module", "Random Array Memory", "Random Access Memory"],
      correctOptionIndex: 3,
      hintText: "RAM is your device's short-term memory — it clears completely when you restart.",
    ),

    // L63 — Visual — count_squares_6
    Puzzle(
      id: 63, levelNumber: 63, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "🔲 Count EVERY square you can see — including combined ones!\nHow many squares in total?",
      correctTargetId: 'count_squares_6',
      hintText: "Three squares in a row: 3 singles + 2 pairs + 1 triple. Most people only count 3!",
    ),

    // L64 — History — multiChoice
    Puzzle(
      id: 64, levelNumber: 64, chapter: 'hard',
      type: PuzzleType.multiChoice,
      question: "📜 The Mona Lisa is famously mysterious.\nWhat feature is she conspicuously MISSING?",
      options: ["Eyelashes 👁️", "Eyebrows 🤨", "Jewelry 💎", "Visible ears"],
      correctOptionIndex: 1,
      hintText: "It was fashionable for noble Florentine women to shave their eyebrows in the 1500s!",
    ),

    // L65 — Mythology — multiChoice
    Puzzle(
      id: 65, levelNumber: 65, chapter: 'hard',
      type: PuzzleType.multiChoice,
      question: "⚡ In Egyptian mythology, Anubis — god of the afterlife — has the head of a…",
      options: ["Cat 🐱", "Hawk 🦅", "Crocodile 🐊", "Jackal 🐺"],
      correctOptionIndex: 3,
      hintText: "He guards the entrance to the underworld and weighs souls against a feather of Ma'at.",
    ),

    // L66 — Visual — green_word
    Puzzle(
      id: 66, levelNumber: 66, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "🎨 Your reading instinct is the enemy here.\nFight it and tap ONLY the word whose INK is GREEN.",
      correctTargetId: 'green_word',
      hintText: "The colour of the letters — not what they spell — is the answer. Stay focused!",
    ),

    // L67 — Problem Solving — multiChoice
    Puzzle(
      id: 67, levelNumber: 67, chapter: 'hard',
      type: PuzzleType.multiChoice,
      question: "🧩 A prisoner must choose between 3 rooms:\n🔫 Firing squad   🔥 Raging inferno\n🦁 Lions that haven't eaten in 3 years\nWhich is SAFEST?",
      options: ["Firing squad 🔫", "Raging fire 🔥", "The lions 🦁", "All equally deadly"],
      correctOptionIndex: 2,
      hintText: "Lions that haven't eaten in 3 years would be... dead. 💀",
    ),

    // L68 — Visual — flip_mom
    Puzzle(
      id: 68, levelNumber: 68, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "💡 A famous word is shown UPSIDE DOWN.\nTurn it right-side up in your mind — what does it say?",
      correctTargetId: 'flip_mom',
      hintText: "This is one of the most loved flip-word tricks. W and M are mirror images of each other!",
    ),

    // L69 — GK — typeAnswer
    Puzzle(
      id: 69, levelNumber: 69, chapter: 'hard',
      type: PuzzleType.typeAnswer,
      question: "🌍 What is the ONLY letter that does NOT appear\nin any US state name? (1 letter)",
      correctAnswer: "q",
      hintText: "Go through the alphabet mentally and check every state. One letter hides perfectly!",
    ),

    // L70 — Visual — odd_star
    Puzzle(
      id: 70, levelNumber: 70, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "⭐ A crowd of stars — but one doesn't quite fit.\nTap the odd star hiding among the others!",
      correctTargetId: 'odd_star',
      hintText: "Solid filled stars vs hollow outlined stars — find the one that's different!",
    ),

    // L71 — Maths — multiChoice
    Puzzle(
      id: 71, levelNumber: 71, chapter: 'hard',
      type: PuzzleType.multiChoice,
      question: "🔢 0.999... (repeating infinitely) is mathematically equal to…",
      options: ["Less than 1", "Almost but not quite 1", "Undefined", "Exactly 1"],
      correctOptionIndex: 3,
      hintText: "Let x=0.999… → 10x=9.999… → 9x=9 → x=1. Mathematical proof! 🤯",
    ),

    // L72 — Visual — c_hidden
    Puzzle(
      id: 72, levelNumber: 72, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "👁️ A crafty C is blending in with a crowd of Os.\nSharpen your eyes and find the imposter!",
      correctTargetId: 'c_hidden',
      hintText: "O is a closed circle. C is open on the right. Find the one that doesn't fully close!",
    ),

    // L73 — Tech — tapTarget
    Puzzle(
      id: 73, levelNumber: 73, chapter: 'hard',
      type: PuzzleType.tapTarget,
      question: "🧪 Tap the invention that was created FIRST (chronologically)",
      options: ["Television 📺", "Email 📧", "Internet 🌐", "Telephone ☎️"],
      correctTargetId: "Telephone ☎️",
      hintText: "Alexander Graham Bell patented it in 1876. The others came 50–100 years later!",
    ),

    // L74 — History — multiChoice
    Puzzle(
      id: 74, levelNumber: 74, chapter: 'hard',
      type: PuzzleType.multiChoice,
      question: "📜 Napoleon Bonaparte was supposedly very short.\nWhat was his ACTUAL height?",
      options: ["4'11\" (150 cm)", "5'2\" (157 cm)", "5'4\" (163 cm)", "5'7\" (170 cm) 📏"],
      correctOptionIndex: 3,
      hintText: "A unit conversion myth — French 'pouce' ≠ English 'inch'. He was average height!",
    ),

    // L75 — Visual — eight_hidden
    Puzzle(
      id: 75, levelNumber: 75, chapter: 'hard',
      type: PuzzleType.visualTrick,
      question: "🔍 The number 8 is hiding here once again.\nBut this time the crowd is trickier — find it!",
      correctTargetId: 'eight_hidden',
      hintText: "8 has two symmetric loops. Letters like B, G, S, Q all try to look like it. Stay sharp!",
    ),

    // ═══════════════════════════════════════════════════════════
    // CHAPTER 4 — EXPERT ZONE  (levels 76–100)
    // 14 visual tricks + 11 other types
    // ═══════════════════════════════════════════════════════════

    // L76 — Visual — count_dots_7
    Puzzle(
      id: 76, levelNumber: 76, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "⚪ Expert dot counter!\nCount all the white dots in this pattern. One wrong and you're back to amateur hour.",
      correctTargetId: 'count_dots_7',
      hintText: "Count row by row. Row 1: 3, Row 2: 2, Row 3: 2. That's 7 total!",
    ),

    // L77 — Mythology — tapTarget
    Puzzle(
      id: 77, levelNumber: 77, chapter: 'expert',
      type: PuzzleType.tapTarget,
      question: "⚡ Tap the Greek goddess of WISDOM",
      options: ["Aphrodite", "Ares", "Artemis", "Athena"],
      correctTargetId: "Athena",
      hintText: "Athens was named after her. She won a contest with Poseidon by gifting an olive tree!",
    ),

    // L78 — Visual — yellow_word
    Puzzle(
      id: 78, levelNumber: 78, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "🎨 Elite Stroop challenge!\nYour reading brain is your enemy. Tap the word printed in YELLOW ink.",
      correctTargetId: 'yellow_word',
      hintText: "Expert players still get caught. Focus only on the literal ink colour you see!",
    ),

    // L79 — Problem Solving — multiChoice
    Puzzle(
      id: 79, levelNumber: 79, chapter: 'expert',
      type: PuzzleType.multiChoice,
      question: "🧩 You flip a fair coin 10 times — all heads.\nWhat is the probability of heads on flip #11?",
      options: ["Less than 50% — tails is overdue", "More than 50% — you're on a roll", "50% exactly", "Cannot be calculated"],
      correctOptionIndex: 2,
      hintText: "Coins have NO memory! Each flip is always 50/50. This is called the Gambler's Fallacy.",
    ),

    // L80 — Visual — mueller_same
    Puzzle(
      id: 80, levelNumber: 80, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "📏 The ultimate line illusion! Expert mode.\nTrust maths: are lines A and B equal, or is one longer?",
      correctTargetId: 'mueller_same',
      hintText: "The length IS identical. The arrow direction exploits your depth perception. Trust the proof!",
    ),

    // L81 — GK — multiChoice
    Puzzle(
      id: 81, levelNumber: 81, chapter: 'expert',
      type: PuzzleType.multiChoice,
      question: "🌍 Honey found in 3,000-year-old Egyptian tombs is still edible.\nWhy doesn't honey EVER spoil?",
      options: ["Special bee enzyme", "Low moisture + antibacterial chemistry", "Crystallises before bacteria forms", "Bees add a natural preservative"],
      correctOptionIndex: 1,
      hintText: "Honey is hygroscopic (absorbs all moisture) + produces hydrogen peroxide. Bacteria can't survive!",
    ),

    // L82 — Visual — odd_triangle
    Puzzle(
      id: 82, levelNumber: 82, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "🔺 Expert eye test!\nOne triangle in this group is pointing the WRONG direction. Find it!",
      correctTargetId: 'odd_triangle',
      hintText: "Nearly all triangles point the same way. The imposter points the OPPOSITE direction!",
    ),

    // L83 — Maths — typeAnswer
    Puzzle(
      id: 83, levelNumber: 83, chapter: 'expert',
      type: PuzzleType.typeAnswer,
      question: "🔢 Magic Maths Trick!\nPick ANY number. Double it. Add 10. Divide by 2. Subtract your original.\nWhat do you ALWAYS get?",
      correctAnswer: "5",
      hintText: "Try with 3, 100, or 999 — it's ALWAYS the same. That's algebra in disguise!",
    ),

    // L84 — Visual — p_hidden
    Puzzle(
      id: 84, levelNumber: 84, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "🔍 Expert hunter required!\nA lone P is hiding in this crowd of Fs. Find it if you dare!",
      correctTargetId: 'p_hidden',
      hintText: "P has a closed loop on top. F has an open top with two horizontal bars. Spot the difference!",
    ),

    // L85 — Visual — flip_6
    Puzzle(
      id: 85, levelNumber: 85, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "🔢 Expert flip! At this level, nothing is what it appears.\nWhat number is actually displayed here when oriented correctly?",
      correctTargetId: 'flip_6',
      hintText: "Rotate 180° mentally. Some numbers are their own doppelgängers when flipped!",
    ),

    // L86 — Tech — multiChoice
    Puzzle(
      id: 86, levelNumber: 86, chapter: 'expert',
      type: PuzzleType.multiChoice,
      question: "🧪 In a full-mesh network, how many connections are needed\nto link 10 computers to each other?",
      options: ["10", "100", "90", "45"],
      correctOptionIndex: 3,
      hintText: "Formula: n(n−1)÷2 = 10×9÷2 = 45. A→B is the same as B→A, so no double counting!",
    ),

    // L87 — Visual — count_f
    Puzzle(
      id: 87, levelNumber: 87, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "🔤 Expert F-counter! Read very slowly.\nCount EVERY capital F in the passage — your brain is programmed to miss some!",
      correctTargetId: 'count_f',
      hintText: "The word 'OF' appears multiple times. Your brain reads it as 'ov' and skips the F every time!",
    ),

    // L88 — History — multiChoice
    Puzzle(
      id: 88, levelNumber: 88, chapter: 'expert',
      type: PuzzleType.multiChoice,
      question: "📜 Which ancient civilisation first invented ZERO as a mathematical number?",
      options: ["Romans 🏛️", "Greeks 🏺", "Egyptians 🪱", "Indians 🇮🇳"],
      correctOptionIndex: 3,
      hintText: "Brahmagupta formally defined zero in 628 AD. Romans couldn't even write it!",
    ),

    // L89 — Visual — ebbinghaus
    Puzzle(
      id: 89, levelNumber: 89, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "🟠 Your brain is CONVINCED the orange circles are different sizes.\nAre they REALLY? Think before you tap!",
      correctTargetId: 'ebbinghaus',
      hintText: "Context deceives perception every single time. The circles are identical — trust the geometry!",
    ),

    // L90 — Mythology — multiChoice
    Puzzle(
      id: 90, levelNumber: 90, chapter: 'expert',
      type: PuzzleType.multiChoice,
      question: "⚡ What did Prometheus steal from the gods to give humanity?",
      options: ["Wisdom 📖", "Immortality ✨", "Fire 🔥", "Music 🎵"],
      correctOptionIndex: 2,
      hintText: "Zeus punished him by chaining him to a rock — an eagle ate his liver daily for eternity!",
    ),

    // L91 — Visual — odd_moon
    Puzzle(
      id: 91, levelNumber: 91, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "🌙 Expert imposter hunt!\nThe night sky has ONE sun hiding among the moons. Tap it!",
      correctTargetId: 'odd_moon',
      hintText: "All moons look crescent-shaped. The imposter shines bright and round like a sun!",
    ),

    // L92 — Problem Solving — typeAnswer
    Puzzle(
      id: 92, levelNumber: 92, chapter: 'expert',
      type: PuzzleType.typeAnswer,
      question: "🧩 What common English word is ALWAYS spelled incorrectly?\n(The answer is hidden inside this very question!)",
      correctAnswer: "incorrectly",
      hintText: "Read the question again — very carefully. The answer is literally written in it.",
    ),

    // L93 — Visual — b_hidden
    Puzzle(
      id: 93, levelNumber: 93, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "🔍 The hardest B-hunt yet!\nSomewhere in this field of 8s, a lone B is hiding. Find it!",
      correctTargetId: 'b_hidden',
      hintText: "8 is symmetrical. B has its larger loop at the BOTTOM. Which tile is asymmetric?",
    ),

    // L94 — GK — multiChoice
    Puzzle(
      id: 94, levelNumber: 94, chapter: 'expert',
      type: PuzzleType.multiChoice,
      question: "🌍 Which is the ONLY mammal that physically cannot jump?",
      options: ["Hippo 🦛", "Rhino 🦏", "Elephant 🐘", "Sloth 🦥"],
      correctOptionIndex: 2,
      hintText: "Despite being powerful swimmers, elephants' bone structure and weight make jumping impossible!",
    ),

    // L95 — Visual — count_squares_6
    Puzzle(
      id: 95, levelNumber: 95, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "🔲 Expert square count! Don't just count the obvious ones.\nHow many squares are hiding in this figure?",
      correctTargetId: 'count_squares_6',
      hintText: "3 singles + 2 double-combos + 1 triple = 6. The combined ones trip everyone up!",
    ),

    // L96 — Maths — multiChoice
    Puzzle(
      id: 96, levelNumber: 96, chapter: 'expert',
      type: PuzzleType.multiChoice,
      question: "🔢 Type 7734 on a calculator.\nTurn it UPSIDE DOWN. What word appears?",
      options: ["HOLE", "BELL", "HEEL", "HELL"],
      correctOptionIndex: 3,
      hintText: "4→h, 3→E, 7→L, 7→L — read right to left upside down. Calculator words are classic!",
    ),

    // L97 — Visual — blue_word
    Puzzle(
      id: 97, levelNumber: 97, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "🎨 The FINAL Stroop test!\nOnly the word printed in BLUE ink counts. Can you beat your reading instinct?",
      correctTargetId: 'blue_word',
      hintText: "You've done this before — but your brain is STILL trying to trick you. Focus on ink!",
    ),

    // L98 — Mythology — tapTarget
    Puzzle(
      id: 98, levelNumber: 98, chapter: 'expert',
      type: PuzzleType.tapTarget,
      question: "⚡ Tap the god who kept the EXACT SAME name in BOTH Greek AND Roman mythology",
      options: ["Zeus / Jupiter", "Apollo", "Ares / Mars", "Poseidon / Neptune"],
      correctTargetId: "Apollo",
      hintText: "The Romans admired this sun god so much they didn't rename him. The only major deity to survive!",
    ),

    // L99 — Visual — flip_mom
    Puzzle(
      id: 99, levelNumber: 99, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "💡 The PENULTIMATE challenge! One iconic word is shown upside down.\nFlip it in your mind — what beautiful word appears?",
      correctTargetId: 'flip_mom',
      hintText: "W → M, O → O, W → M. Three letters. One of the most elegant word flips in English!",
    ),

    // L100 — Visual — level_100 (meta-trick)
    Puzzle(
      id: 100, levelNumber: 100, chapter: 'expert',
      type: PuzzleType.visualTrick,
      question: "🏆 FINAL LEVEL — BRAIN MASTER!\n10² = ?\nThe answer is right here in front of you. Tap it if you can find it!",
      correctTargetId: 'level_100',
      hintText: "10² = 100. You are on Level 100. The answer is literally at the top of this screen. 👆",
    ),

  ];

  static Puzzle getByLevel(int levelIndex) => puzzles[levelIndex];
  static int get totalCount => puzzles.length;

  static List<Puzzle> getChapter(String chapter) =>
      puzzles.where((p) => p.chapter == chapter).toList();
}
