/*
 * Aadarsh Patel
 * 118676722
 * apatel66
 */

#include "executor.h"
#include "command.h"

#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/types.h>
#include <sys/wait.h>
#include <sysexits.h>
#include <unistd.h>

/* All Function Prototypes */
/*static void print_tree(struct tree *t);*/
int execute(struct tree *t);
int execute_auxilliary(struct tree *t, int parent_input_fd,
                       int parent_output_fd);
static void error_check(int ret_result, const char *error_message);

/*static void print_tree(struct tree *t) {
  if (t != NULL) {
    print_tree(t->left);

    if (t->conjunction == NONE) {
      printf("NONE: %s, ", t->argv[0]);
    } else {
      printf("%s, ", conj[t->conjunction]);
    }
    printf("IR: %s, ", t->input);
    printf("OR: %s\n", t->output);

    print_tree(t->right);
  }
}*/

/* Used to check if there was an error performing any operations (fork, dup2,
 * open, close, etc.) */
static void error_check(int ret_result, const char *error_message) {

  if (ret_result == -1) {
    perror(error_message);
    exit(EX_OSERR);
  }
}

/* Designed a shell that processes linux and shell commands with PIPES, AND, and SUBSHELL operators*/
int execute(struct tree *t) {

  /*print_tree(t);*/

  return execute_auxilliary(t, STDIN_FILENO, STDOUT_FILENO);
}

/* Recursive function that handles user commands */
int execute_auxilliary(struct tree *t, int parent_input_fd,
                       int parent_output_fd) {
  pid_t result;
  int ret_result, left_status, pipe_fd[2];
  char *location;

  if (t->conjunction == NONE) { /* processing NONE conjunction */

    if (!strcmp(t->argv[0], "exit")) { /* exit shell */

      exit(0);

    } else if (!strcmp(t->argv[0], "cd")) { /* changing directory */

      if (t->argv[1] == NULL) {

        location = getenv("HOME");
        chdir(location);

      } else {

        chdir(t->argv[1]);
      }
    } else { /* handles linux commands */

      result = fork(); /* Forking */
      error_check(result, "fork error (NONE)");

      if (result > 0) { /* Parent code */

        wait(&ret_result);
        return ret_result;

      } else { /* Child code */

        if (t->input != NULL) { /* input redirection */

          ret_result = parent_input_fd = open(t->input, O_RDONLY);
          error_check(ret_result, "open error (NONE)");

          ret_result = dup2(parent_input_fd, STDIN_FILENO);
          error_check(ret_result, "dup2 error (NONE)");
          ret_result = close(parent_input_fd);
          error_check(ret_result, "close error (NONE)");
        }

        if (t->output != NULL) { /* output redirection */
          ret_result = parent_output_fd =
              open(t->output, O_WRONLY | O_CREAT | O_TRUNC, 0664);
          error_check(ret_result, "open error (NONE)");

          ret_result = dup2(parent_output_fd, STDOUT_FILENO);
          error_check(ret_result, "dup2 error (NONE)");
          ret_result = close(parent_output_fd);
          error_check(ret_result, "close error (NONE)");
        }

        execvp(t->argv[0], t->argv); /* executes the given command */

        fprintf(stderr, "Failed to execute %s\n", t->argv[0]);
        fflush(stdout);
        exit(EX_OSERR);
      }
    }
  } else if (t->conjunction == AND) { /* processing AND conjunction */

    if (t->input) {
      ret_result = parent_input_fd = open(t->input, O_RDONLY);
      error_check(ret_result, "open error (AND)");
    }

    if (t->output) {
      ret_result = parent_output_fd =
          open(t->output, O_WRONLY | O_CREAT | O_TRUNC, 0664);
      error_check(ret_result, "open error (AND)");
    }

    left_status = execute_auxilliary(
        t->left, parent_input_fd,
        parent_output_fd); /* recursive call on left sub tree */

    if (left_status == 0) { /* only process right subtree if left subtree is
                               processed successfully */
      execute_auxilliary(
          t->right, parent_input_fd,
          parent_output_fd); /* recursive call on right sub tree*/
    }

  } else if (t->conjunction == PIPE) { /* processing PIPE conjunction */

    if (t->left->output != NULL || t->right->input != NULL) {

      if (t->left->output != NULL) {
        printf("Ambiguous output redirect.\n");
      } else {
        printf("Ambiguous input redirect.\n");
      }

    } else {

      if (t->input != NULL) {
        ret_result = parent_input_fd = open(t->input, O_RDONLY);
        error_check(ret_result, "open error (PIPE)");
      }

      if (t->output != NULL) {
        ret_result = parent_output_fd =
            open(t->output, O_WRONLY | O_CREAT | O_TRUNC, 0664);
        error_check(ret_result, "open error (PIPE)");
      }

      ret_result = pipe(pipe_fd); /* piping hot */
      error_check(ret_result, "pipe error");

      result = fork(); /* forking */
      error_check(result, "fork error (PIPE)");

      if (result > 0) { /* Parent code */

        close(pipe_fd[1]);
        ret_result = dup2(pipe_fd[0], STDIN_FILENO);
        error_check(ret_result, "dup2 error (PIPE)");

        execute_auxilliary(
            t->right, pipe_fd[0],
            parent_output_fd); /* recursive call on right sub tree*/

        close(pipe_fd[0]);
        wait(NULL);

      } else { /* Child code */

        close(pipe_fd[0]);
        ret_result = dup2(pipe_fd[1], STDOUT_FILENO);
        error_check(ret_result, "dup2 error (PIPE)");

        execute_auxilliary(t->left, parent_input_fd,
                           pipe_fd[1]); /* recursive call on left sub tree*/

        close(pipe_fd[1]);
        exit(0);
      }
    }
  } else if (t->conjunction == SUBSHELL) { /* processing SUBSHELL conjunction */

    if (t->input != NULL) {
      ret_result = parent_input_fd = open(t->input, O_RDONLY);
      error_check(ret_result, "open error (SUBSHELL)");
    }

    if (t->output != NULL) {
      ret_result = parent_output_fd =
          open(t->output, O_WRONLY | O_CREAT | O_TRUNC, 0664);
      error_check(ret_result, "open error (SUBSHELL)");
    }

    result = fork(); /* Forking */
    error_check(result, "fork error (SUBSHELL)");

    if (result > 0) { /* Parent code */

      wait(&ret_result);
    } else { /* Child code */

      execute_auxilliary(t->left, parent_input_fd,
                         parent_output_fd); /* processing left sub tree */
      exit(0);
    }

  } else {
  }

  return 0;
}
