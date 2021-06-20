import java.util.*;

public class IDS{
    final static int N = 9;
    final static int Q = 181440;
    final static int S = 0;
    final static int max_move = 31;

    static int path = 0;

    static int[][] adjacent = {
        {1, 3, -1},       // 0
        {0, 2, 4, -1},    // 1
        {1, 5, -1},       // 2
        {0, 4, 6, -1},    // 3
        {1, 3, 5, 7, -1}, // 4
        {2, 4, 8, -1},    // 5
        {3, 7, -1},       // 6
        {4, 6, 8, -1},    // 7
        {5, 7, -1}        // 8
    };

    static int[] board = new int[N];
    final static int[] goal = {1,2,3,4,5,6,7,8,0};
    static int[] move_piece = new int[max_move+1];
    static int count = 0;

    static void print_answer(int n){
        count++;
        for(int i=1;i<=n;i++){
            System.out.print(move_piece[i]);
        }
        System.out.println(" "+n);
    }

    static boolean same(int[] board, int[] goal){
        for(int i=0;i<N;i++){
            if(board[i]!=goal[i]){
                return false;
            }
        }
        return true;
    }

    static void dfs(int n, int space, int limit, int[] goal){
        if(n==limit){
            path++;
            if(same(board, goal)){
                //System.out.println(path);
                print_answer(n);
            }
        }else{
            for (int i = 0; adjacent[space][i] != -1; i++) {
                int x = adjacent[space][i];
                // 同じコマを動かすと元の局面に戻る
                if (board[x] == move_piece[n]) continue;
                path++;
                move_piece[n + 1] = board[x];
                board[space] = board[x];
                board[x] = S;
                dfs(n + 1, x, limit, goal);
                board[x] = board[space];
                board[space] = S;
              }
        }
    }
    
    public static void main(String[] args){
        Scanner sc = new Scanner(System.in);
        board = new int[N];
        int space = 0;
        for(int i=0; i<N; i++){
            board[i] = sc.nextInt();
            if(board[i] == 0){
                space = i;
            }
        }
        sc.close();
        long start_time = System.currentTimeMillis();
        move_piece[0] = 0;
        for (int i = 1; i <= max_move; i++) {
            dfs(0, space, i, goal);
            if (count > 0) break;
            
        }
        System.out.println("path: "+path);
        System.out.println("how many: "+count);
        long end_time = System.currentTimeMillis();
        System.out.println("実行時間："+(end_time-start_time)+"ms");
    }
}
