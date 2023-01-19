#include "state.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "snake_utils.h"

/* Helper function definitions */
static void set_board_at(game_state_t *state, unsigned int row, unsigned int col, char ch);
static bool is_tail(char c);
static bool is_head(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static char head_to_body(char c);
static unsigned int get_next_row(unsigned int cur_row, char c);
static unsigned int get_next_col(unsigned int cur_col, char c);
static void find_head(game_state_t *state, unsigned int snum);
static char next_square(game_state_t *state, unsigned int snum);
static void update_tail(game_state_t *state, unsigned int snum);
static void update_head(game_state_t *state, unsigned int snum);

/* Task 1 */
game_state_t *create_default_state()
{
  // TODO: Implement this function.
  game_state_t *game = (game_state_t *)malloc(sizeof(game_state_t));
  if (!game)
  {
    printf("Error, cannot create game\n");
  }
  game->num_rows = 18;
  unsigned int width = 20;
  unsigned int depth = game->num_rows;
  printf("width: %u, depth: %u\n", width, depth);
  game->board = (char **)malloc(sizeof(char *) * depth);
  if (!game->board)
  {
    printf("Error, cannot create game->board\n");
  }
  for (int i = 0; i < depth; i++)
  {
    game->board[i] = (char *)malloc(sizeof(char) * width);
    for (int j = 0; j < width; j++)
    {
      if (i == 0 || i == depth - 1 || j == 0 || j == width - 1)
      {
        game->board[i][j] = '#';
      }
      else
      {
        game->board[i][j] = ' ';
      }
    }
  }
  set_board_at(game, 2, 9, '*');
  set_board_at(game, 2, 2, 'd');
  set_board_at(game, 2, 3, '>');
  set_board_at(game, 2, 4, 'D');
  game->num_snakes = 1;
  game->snakes = (snake_t *)malloc(sizeof(snake_t) * game->num_snakes);
  if (!game->snakes)
  {
    printf("Error, cannot create game->snakes\n");
  }
  game->snakes->live = true;
  game->snakes->head_row = 2;
  game->snakes->head_col = 4;
  game->snakes->tail_row = 2;
  game->snakes->tail_col = 2;
  return game;
}

/* Task 2 */
void free_state(game_state_t *state)
{
  // TODO: Implement this function.
  for (int i = 0; i < state->num_rows; i++)
  {
    free(state->board[i]);
  }
  free(state->board);
  printf("state.board successfully freed.\n");
  free(state->snakes);
  printf("state.snakes successfully freed.\n");
  free(state);
  printf("state successfully freed.\n");
  return;
}

/* Task 3 */
void print_board(game_state_t *state, FILE *fp)
{
  // TODO: Implement this function.
  for (int i = 0; i < state->num_rows; i ++ ) {
    fprintf(fp, "%s\n", state->board[i]);
  }
  return;
}

/*
  Saves the current state into filename. Does not modify the state object.
  (already implemented for you).
*/
void save_board(game_state_t *state, char *filename)
{
  FILE *f = fopen(filename, "w");
  print_board(state, f);
  fclose(f);
}

/* Task 4.1 */

/*
  Helper function to get a character from the board
  (already implemented for you).
*/
char get_board_at(game_state_t *state, unsigned int row, unsigned int col)
{
  return state->board[row][col];
}

/*
  Helper function to set a character on the board
  (already implemented for you).
*/
static void set_board_at(game_state_t *state, unsigned int row, unsigned int col, char ch)
{
  state->board[row][col] = ch;
}

/*
  Returns true if c is part of the snake's tail.
  The snake consists of these characters: "wasd"
  Returns false otherwise.
*/
static bool is_tail(char c)
{
  // TODO: Implement this function.
  char *str = "wasd";
  while (*str != '\0') 
  {
    if (c == *str) 
    {
      return true;
    }
    str++;
  }
  return false;
}

/*
  Returns true if c is part of the snake's head.
  The snake consists of these characters: "WASDx"
  Returns false otherwise.
*/
static bool is_head(char c)
{
  // TODO: Implement this function.
  char *str = "WASDx";
  while (*str != '\0')
  {
    if (c == *str)
    {
      return true;
    } 
    str++;
  }
  return false;
}

/*
  Returns true if c is part of the snake.
  The snake consists of these characters: "wasd^<v>WASDx"
*/
static bool is_snake(char c)
{
  // TODO: Implement this function.
  char *str = "wasd^<v>WASDx";
  while (*str != '\0')
  {
    if (c == *str)
    {
      return true;
    }
    str++;
  }
  return false;
}

/*
  Converts a character in the snake's body ("^<v>")
  to the matching character representing the snake's
  tail ("wasd").
*/
static char body_to_tail(char c)
{
  // TODO: Implement this function.
  char convert = ' ';
  switch (c)
  {
  case '^':
    convert = 'w';
    break;
  case '<':
    convert = 'a';
    break;
  case 'v':
    convert = 's';
    break;
  case '>':
    convert = 'd';
    break;
  default:
    break;
  }
  return convert;
}

/*
  Converts a character in the snake's head ("WASD")
  to the matching character representing the snake's
  body ("^<v>").
*/
static char head_to_body(char c)
{
  // TODO: Implement this function.
  char convert = ' ';
  switch (c)
  {
  case 'W':
    convert = '^';
    break;
  case 'A':
    convert = '<';
    break;
  case 'S':
    convert = 'v';
    break;
  case 'D':
    convert = '>';
    break;
  default:
    break;
  }
  return convert;
}

/*
  Returns cur_row + 1 if c is 'v' or 's' or 'S'.
  Returns cur_row - 1 if c is '^' or 'w' or 'W'.
  Returns cur_row otherwise.
*/
static unsigned int get_next_row(unsigned int cur_row, char c)
{
  if (c == 'v' || c == 's' || c == 'S')
  {
    return cur_row + 1;
  } 
  else if (c == '^' || c == 'w' || c == 'W')
  {
    return cur_row - 1;
  }
  return cur_row;
}

/*
  Returns cur_col + 1 if c is '>' or 'd' or 'D'.
  Returns cur_col - 1 if c is '<' or 'a' or 'A'.
  Returns cur_col otherwise.
*/
static unsigned int get_next_col(unsigned int cur_col, char c)
{
  if (c == '>' || c == 'd' || c == 'D')
  {
    return cur_col + 1;
  }
  else if (c == '<' || c == 'a' || c == 'A')
  {
    return cur_col - 1;
  }
  return cur_col;
}

/*
  Task 4.2

  Helper function for update_state. Return the character in the cell the snake is moving into.

  This function should not modify anything.
*/
static char next_square(game_state_t *state, unsigned int snum)
{
  // TODO: Implement this function.
  unsigned int head_x = state->snakes[snum].head_row;
  unsigned int head_y = state->snakes[snum].head_col;
  char snake_head = state->board[head_x][head_y];
  unsigned int dx = get_next_row(head_x, snake_head);
  unsigned int dy = get_next_col(head_y, snake_head);
  return state->board[dx][dy];
}

/*
  Task 4.3

  Helper function for update_state. Update the head...

  ...on the board: add a character where the snake is moving

  ...in the snake struct: update the row and col of the head

  Note that this function ignores food, walls, and snake bodies when moving the head.
*/
static void update_head(game_state_t *state, unsigned int snum)
{
  // TODO: Implement this function.
  unsigned int head_x = state->snakes[snum].head_row;
  unsigned int head_y = state->snakes[snum].head_col;
  char snake_head = state->board[head_x][head_y];
  state->board[head_x][head_y] = head_to_body(state->board[head_x][head_y]);
  unsigned int dx = get_next_row(head_x, snake_head);
  unsigned int dy = get_next_col(head_y, snake_head);
  state->board[dx][dy] = snake_head;
  state->snakes[snum].head_row = dx;
  state->snakes[snum].head_col = dy;
  return;
}

/*
  Task 4.4

  Helper function for update_state. Update the tail...

  ...on the board: blank out the current tail, and change the new
  tail from a body character (^<v>) into a tail character (wasd)

  ...in the snake struct: update the row and col of the tail
*/
static void update_tail(game_state_t *state, unsigned int snum)
{
  // TODO: Implement this function.
  unsigned int tail_x = state->snakes[snum].tail_row;
  unsigned int tail_y = state->snakes[snum].tail_col;
  char snake_tail = state->board[tail_x][tail_y];
  state->board[tail_x][tail_y] = ' ';
  unsigned int dx = get_next_row(tail_x, snake_tail);
  unsigned int dy = get_next_col(tail_y, snake_tail);
  state->board[dx][dy] = body_to_tail(state->board[dx][dy]);
  state->snakes[snum].tail_row = dx;
  state->snakes[snum].tail_col = dy;
  return;
}

/* Task 4.5 */
void update_state(game_state_t *state, int (*add_food)(game_state_t *state))
{
  // TODO: Implement this function.
  unsigned int snum = state->num_snakes;
  for (unsigned int i = 0; i < snum ; i++)
  {
    char next_step = next_square(state, i);
    if (is_snake(next_step))
    {
      state->board[state->snakes[i].head_row][state->snakes[i].head_col] = 'x';
      state->snakes[i].live = false;
    }
    switch(next_step)
    {
      case ' ':
        update_head(state, i);
        update_tail(state, i);
        break;
      case '#':
        state->board[state->snakes[i].head_row][state->snakes[i].head_col] = 'x';
        state->snakes[i].live = false;
        break;
      case '*':
        update_head(state, i);
        add_food(state);
    }
  }
  return;
}

/* Task 5 */
game_state_t *load_board(char *filename)
{
  FILE *fp = NULL;
  fp = fopen(filename, "r");
  if(fp == NULL) {
    return NULL;
  }

  game_state_t* game_state = malloc(sizeof(game_state_t));

  char *buff = malloc(1024 * 1024 * sizeof(char));
  unsigned int cnt = 0;
  while(!feof(fp)) {
    fgets(buff, 1024 * 1024, fp);
	  cnt ++ ;
	}
  fclose(fp);
  free(buff);

  fp = fopen(filename, "r");
  game_state->num_rows = cnt - 1;
  game_state->board = malloc(sizeof(char*) * game_state->num_rows);

  for(int i = 0; i < game_state -> num_rows; i ++ ) {
    buff = malloc(1024 * 1024 * sizeof(char));
    fgets(buff, 1024 * 1024, fp);
    game_state->board[i] = malloc((strlen(buff)) * sizeof(char));
    strncpy(game_state->board[i], buff, strlen(buff));
    game_state->board[i][strlen(buff) - 1] = '\0';
    free(buff);
  }
  fclose(fp);

  return game_state;
}

/*
  Task 6.1

  Helper function for initialize_snakes.
  Given a snake struct with the tail row and col filled in,
  trace through the board to find the head row and col, and
  fill in the head row and col in the struct.
*/
static void find_head(game_state_t *state, unsigned int snum)
{
  snake_t* snake = &state->snakes[snum];
  unsigned int cur_row = snake->tail_row;
  unsigned int cur_col = snake->tail_col;
  char cur_char = state->board[cur_row][cur_col];

  while(!is_head(cur_char)) {
    cur_row = get_next_row(cur_row, cur_char);
    cur_col = get_next_col(cur_col, cur_char);
    cur_char = state->board[cur_row][cur_col];
  }

  snake->head_row = cur_row;
  snake->head_col = cur_col;
  return;
}

/* Task 6.2 */
game_state_t *initialize_snakes(game_state_t *state)
{
  if(state == NULL) {
    return NULL;
  }

  unsigned int snake_num = 0;
  unsigned int *tail_rows = malloc(sizeof(unsigned int) * 1000);
  unsigned int *tail_cols = malloc(sizeof(unsigned int) * 1000);

  for (unsigned int i = 0; i < state->num_rows; i ++ ) {
    for(unsigned int j = 0; j < strlen(state->board[i]); j ++ ) {
      if(is_tail(state->board[i][j])) {
        tail_rows[snake_num] = i;
        tail_cols[snake_num] = j;
        snake_num ++ ;
      }
    }
  }

  snake_t* snakes = malloc(sizeof(snake_t) * snake_num);
  state->snakes = snakes;
  state->num_snakes = snake_num;
  for(unsigned int i = 0; i < snake_num; i ++ ) {
    snakes[i].tail_row = tail_rows[i];
    snakes[i].tail_col = tail_cols[i];
    snakes[i].live = 1;
    find_head(state, i);
  }
  free(tail_cols);
  free(tail_rows);
  
  return state;
}
