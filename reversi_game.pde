// ゲーム選択を管理する変数
int GameSelection = 0;

// オセロクラス
class Othello {
  // 盤面の状態を保持する2次元配列
  int[][] array = new int[8][8];
  int d = 120; // 石の直径
  float dx = width / 8; // 横の間隔
  float dy = height / 8; // 縦の間隔
  int colorJudge = 1; // 1: 白, 2: 黒
  boolean isSinglePlayer; // シングルプレイヤーかどうか

  // コンストラクタで盤面を初期化
  Othello(boolean singlePlayer) {
    isSinglePlayer = singlePlayer; // モードを設定
    resetBoard(); // 盤面を初期化
  }

  void resetBoard() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        array[i][j] = 0; // 全てのセルを空に設定
      }
    }
    array[3][3] = 1; // 白
    array[3][4] = 2; // 黒
    array[4][3] = 2; // 黒
    array[4][4] = 1; // 白
  }

  // 盤面と石を描画するメソッド
  void display() {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        // セルに石がある場合に描画
        if (array[i][j] != 0) {
          if (array[i][j] == 1) {
            fill(255); // 白
          } else {
            fill(0); // 黒
          }
          // 石を描画
          ellipse(dx * i + dx / 2, dy * j + dy / 2, d, d);
        }
      }
    }
    fill(255,50,0);
    textSize(32);
    textAlign(LEFT, TOP);
    // プレイヤーのスコアを表示
    text("Player 1 (White) Score: " + countStones(1), 10, 10);
    text("Player 2 (Black) Score: " + countStones(2), 10, 50);
    markValidMoves(); // 有効な手の場所にマークを表示
    // プレイヤーのターンを表示
    text("Current Turn: " + (colorJudge == 1 ? "White" : "Black"), width - 300, 10);
    
    // 勝利判定を追加
    checkWin();
  }

  // プレイヤーの石の数を数えるメソッド
  int countStones(int player) {
    int count = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (array[i][j] == player) {
          count++; // プレイヤーの石をカウント
        }
      }
    }
    return count; // スコアを返す
  }

  // 有効な手かどうかを判定するメソッド
  boolean isValidMove(int x, int y, int player) {
    if (array[x][y] != 0) return false; // セルが空でない場合は無効
    int opponent = (player == 1) ? 2 : 1; // 相手のプレイヤーを決定
    boolean valid = false;
    // 8方向を調べるための配列
    int[] dx = {-1, -1, -1, 0, 1, 1, 1, 0};
    int[] dy = {-1, 0, 1, 1, 1, 0, -1, -1};
    // 各方向に対してループ
    for (int dir = 0; dir < 8; dir++) {
      int nx = x + dx[dir];
      int ny = y + dy[dir];
      boolean foundOpponent = false;
      while (nx >= 0 && nx < 8 && ny >= 0 && ny < 8 && array[nx][ny] == opponent) {
        foundOpponent = true; // 相手の石を見つけた
        nx += dx[dir];
        ny += dy[dir];
      }
      if (foundOpponent && nx >= 0 && nx < 8 && ny >= 0 && ny < 8 && array[nx][ny] == player) {
        valid = true; // 有効な手が見つかった
      }
    }
    return valid; // 有効な手の結果を返す
  }

  // 有効な手を実行し、石を反転させるメソッド
  void makeMove(int x, int y, int player) {
    int opponent = (player == 1) ? 2 : 1; // 相手のプレイヤーを決定
    int[] dx = {-1, -1, -1, 0, 1, 1, 1, 0}; // 8方向
    int[] dy = {-1, 0, 1, 1, 1, 0, -1, -1}; // 8方向
    for (int dir = 0; dir < 8; dir++) {
      int nx = x + dx[dir];
      int ny = y + dy[dir];
      boolean foundOpponent = false; // 相手の石を見つけたかどうか
      while (nx >= 0 && nx < 8 && ny >= 0 && ny < 8 && array[nx][ny] == opponent) {
        foundOpponent = true; // 相手の石を見つけた
        nx += dx[dir];
        ny += dy[dir];
      }
      if (foundOpponent && nx >= 0 && nx < 8 && ny >= 0 && ny < 8 && array[nx][ny] == player) {
        // 相手の石を反転させる
        nx = x + dx[dir];
        ny = y + dy[dir];
        while (array[nx][ny] == opponent) {
          array[nx][ny] = player; // 石を反転
          nx += dx[dir];
          ny += dy[dir];
        }
      }
    }
    array[x][y] = player; // 自分の石を置く
  }

  // プレイヤーに有効な手があるかどうかを確認するメソッド
  boolean hasValidMove(int player) {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (isValidMove(i, j, player)) {
          return true; // 有効な手が見つかった
        }
      }
    }
    return false; // 有効な手がない
  }

// 有効な手の場所にマークを表示するメソッド
void markValidMoves() {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (isValidMove(i, j, colorJudge)) {
        if (colorJudge == 1) {
          fill(255); // 白色
        } else {
          fill(0); // 黒色
        }
        ellipse(dx * i + dx / 2, dy * j + dy / 2, d / 4, d / 4); // マークを描画
      }
    }
  }
}


  // ターン管理のための変数
boolean isPlayerTurn = true; // プレイヤーのターンかどうか
boolean skipTurnPlayer1 = false; // プレイヤー1がパスしたか
boolean skipTurnPlayer2 = false; // プレイヤー2がパスしたか

// 勝利判定を追加するメソッド
void checkWin() {
  if (!hasValidMove(1) && !hasValidMove(2)) {
    // 両プレイヤーが有効な手を持っていない場合
    int score1 = countStones(1);
    int score2 = countStones(2);
    String message;
    if (score1 > score2) {
      message = "Player 1 (White) Wins!";
    } else if (score2 > score1) {
      message = "Player 2 (Black) Wins!";
    } else {
      message = "It's a Draw!";
    }
    displayWinMessage(message); // 勝利メッセージを表示
  }
}

  // 勝利メッセージを表示するメソッド
  void displayWinMessage(String message) {
    background(0); // 背景を黒に
    fill(255); // 白色
    textSize(32);
    textAlign(CENTER, CENTER);
    text(message, width / 2, height / 2); // メッセージを中央に表示
    
    // 戻るためのメッセージを表示
    textSize(20);
    text("Press 'R' to return to the Game Hub", width / 2, height / 2 + 50); // 戻るメッセージ
    noLoop(); // ゲームの描画を停止
  }

  // AIの手を実行するメソッド
  void aiMove() {
    int bestX = -1;
    int bestY = -1;
    int maxFlips = -1;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (isValidMove(i, j, 2)) { // 有効な手を探す
          // 仮にその手を実行してみて反転する数を数える
          int flips = countFlips(i, j, 2);
          if (flips > maxFlips) {
            bestX = i;
            bestY = j;
            maxFlips = flips;
          }
        }
      }
    }
    if (bestX != -1 && bestY != -1) {
      makeMove(bestX, bestY, 2); // 最適な手を実行
    }
  }

  // ある手で反転する石の数を数えるメソッド
  int countFlips(int x, int y, int player) {
    int opponent = (player == 1) ? 2 : 1;
    int[] dx = {-1, -1, -1, 0, 1, 1, 1, 0};
    int[] dy = {-1, 0, 1, 1, 1, 0, -1, -1};
    int totalFlips = 0;
    for (int dir = 0; dir < 8; dir++) {
      int nx = x + dx[dir];
      int ny = y + dy[dir];
      int flips = 0;
      while (nx >= 0 && nx < 8 && ny >= 0 && ny < 8 && array[nx][ny] == opponent) {
        flips++;
        nx += dx[dir];
        ny += dy[dir];
      }
      if (flips > 0 && nx >= 0 && nx < 8 && ny >= 0 && ny < 8 && array[nx][ny] == player) {
        totalFlips += flips; // その方向の反転数を追加
      }
    }
    return totalFlips;
  }


  // マウスがクリックされたときの処理
void mouseJudge(float x, float y) {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (dx * i <= x && dx * (i + 1) >= x && dy * j <= y && dy * (j + 1) >= y) {
        if (array[i][j] == 0 && isValidMove(i, j, colorJudge)) {
          // 有効な手であれば石を置く
          makeMove(i, j, colorJudge);
          skipTurnPlayer1 = false; // パス状態をリセット
          skipTurnPlayer2 = false; // パス状態をリセット
          if (isSinglePlayer) {
            if (hasValidMove(2)) {
              colorJudge = 2; // AIのターンにする
              aiMove(); // AIの手を実行
              colorJudge = 1; // プレイヤーのターンに戻す
            } else {
              skipTurnPlayer1 = true; // プレイヤー1がパス
              if (!hasValidMove(1)) {
                // プレイヤー1がパスした後、プレイヤー2のターン
                if (hasValidMove(2)) {
                  colorJudge = 2;
                  aiMove(); // AIの手を実行
                } else {
                  skipTurnPlayer2 = true; // プレイヤー2もパス
                }
              }
            }
          } else {
            colorJudge = (colorJudge == 1) ? 2 : 1; // プレイヤーを切り替える
            // ターンを切り替える前に有効な手の有無を確認
            if (!hasValidMove(colorJudge)) {
              if (colorJudge == 1) {
                skipTurnPlayer1 = true; // プレイヤー1がパス
                colorJudge = 2; // プレイヤー2のターンに切り替え
              } else {
                skipTurnPlayer2 = true; // プレイヤー2がパス
                colorJudge = 1; // プレイヤー1のターンに切り替え
              }
              // プレイヤー2の有効な手を確認
              if (hasValidMove(colorJudge)) {
                if (colorJudge == 2) {
                  // プレイヤー2のターンにAIが行動
                  aiMove();
                }
              }
            }
          }
        }
      }
    }
  }
}
}

// メインプログラムの設定
Othello o;

// ゲームのヘルプ表示フラグ
boolean showHelp = false; // ヘルプを表示するかどうか

void setup() {
  size(1000, 1000);
  o = new Othello(false); // 初期は2人用モード
}

// 描画ループ
void draw() {
  if (GameSelection == 0) {
    displayGameHub(); // ゲームハブを表示
  } else if (GameSelection == 1) {
    OthelloGameLine(); // オセロのラインを表示
    o.display(); // Othelloオブジェクトの表示
  }
  
  // ヘルプを表示する場合
  if (showHelp) {
    displayHelp(); // ヘルプ画面を表示
  }
}

// ゲームハブを表示するメソッド
void displayGameHub() {
  // グラデーション背景の描画
  for (int i = 0; i < height; i++) {
    // 各行の色を線形補間を使って計算
    float inter = map(i, 0, height, 0, 1); // 行の位置に基づいて補間
    // 色を補間してグラデーションを生成
    int c = lerpColor(color(0, 102, 204), color(255, 204, 0), inter);
    stroke(c); // 線の色を設定
    line(0, i, width, i); // 各行を描画
  }
  
  // タイトルの描画
  fill(255); // タイトルの色を白に設定
  textSize(48); // フォントサイズを48に設定
  textAlign(CENTER, CENTER); // テキストの位置を中央に設定
  text("Welcome to the Game Hub", width / 2, height / 4); // タイトルを画面中央に描画
  
  // ボタンの描画
  drawButton(width / 2 - 75, height / 2 - 25, "Single Player"); // 1人用モードボタン
  drawButton(width / 2 - 75, height / 2 + 50, "Two Players"); // 2人用モードボタン
  drawButton(width / 2 - 75, height / 2 + 125, "Help"); // ヘルプボタン
}

void drawButton(float x, float y, String label) {
  // ボタンの背景を描画
  fill(255, 204, 0); // ボタンの色を設定
  rect(x, y, 200, 50, 20); // ボタンを描画（幅を200に変更）
  
  // ボタンの影を描画
  fill(0, 100); // 影の色を設定
  rect(x + 5, y + 5, 200, 50, 20); // ボタンの影を描画（位置をずらして描画）
  
  // ボタンのラベルを描画
  fill(0); // ラベルの色を黒に設定
  textSize(20); // フォントサイズを20に設定
  textAlign(CENTER, CENTER); // テキストの位置を中央に設定
  text(label, x + 100, y + 25); // ボタンのラベルを中央に描画（x + 100に修正）
}

// ヘルプ画面を表示するメソッド
void displayHelp() {
  background(255); // 背景を白に
  fill(0); // 文字色を黒に
  textSize(24);
  textAlign(LEFT, TOP);
  
  // ヘルプの内容
  String helpText = "Othello Game Rules:\n\n" +
                    "1. The game is played on an 8x8 board.\n" +
                    "2. Players take turns placing their stones on the board.\n" +
                    "3. A player can capture the opponent's stones by enclosing them between two of their own stones.\n" +
                    "4. The game ends when the board is full or neither player can make a valid move.\n" +
                    "5. The player with the most stones at the end of the game wins.\n\n" +
                    "Press 'R' to return to the Game Hub.";
  
  text(helpText, 50, 50); // ヘルプのテキストを表示
}


// オセロの盤面を描画するメソッド
void OthelloGameLine() {
  background(0, 250, 154); // 背景色を設定
  // 盤面のラインを描画
  for (int i = 1; i < 8; i++) {
    line(width / 8 * i, 0, width / 8 * i, height);
    line(0, height / 8 * i, width, height / 8 * i);
  }
}

// マウスがクリックされたときの処理
void mousePressed() {
  // プレイボタンがクリックされた場合（1人用）
  if (GameSelection == 0 && mouseX > width / 2 - 75 && mouseX < width / 2 + 75 && mouseY > height / 2 - 25 && mouseY < height / 2 + 25) {
    GameSelection = 1; // ゲームセレクションをオセロに変更
    o = new Othello(true); // シングルプレイヤーモード
  }
  
  // プレイボタンがクリックされた場合（2人用）
  if (GameSelection == 0 && mouseX > width / 2 - 75 && mouseX < width / 2 + 75 && mouseY > height / 2 + 50 && mouseY < height / 2 + 100) {
    GameSelection = 1; // 2人用もオセロに変更
    o = new Othello(false); // 2人用モード
  }
  
  // ヘルプボタンがクリックされた場合
  if (GameSelection == 0 && mouseX > width / 2 - 75 && mouseX < width / 2 + 75 && mouseY > height / 2 + 125 && mouseY < height / 2 + 175) {
    showHelp = true; // ヘルプを表示するフラグをセット
  }
  
  // 盤面内でのマウスクリック処理
  if (GameSelection == 1) {
    o.mouseJudge(mouseX, mouseY); // オセロの判定
  }
}

// キーが押されたときの処理
void keyPressed() {
  if (key == 'r' || key == 'R') {
    GameSelection = 0; // ゲームハブに戻る
    loop();
    o.resetBoard();
    showHelp = false; // ヘルプ表示をリセット
  }
}
