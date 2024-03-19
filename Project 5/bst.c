#include "bst.h"

/**
 * Allocates and initializes the binary search tree (BST) with the passed in comparator, destructor, and printer functions.
 *
 * Assume the tree starts without any nodes when setting the root and num_nodes.
 *
 * @param comparator the comparator function for the BST
 * @param destructor the destructor function for the BST
 * @param printer the printer function for the BST
 * @return a pointer to the newly constructed binary_search_tree struct, NULL if malloc fails
 */
binary_search_tree *init_tree(int (*comparator)(const void *, const void*),
                              void (*destructor)(void *),
                              void (*printer)(FILE *f, void *)) {
    //TODO
    UNUSED(comparator);
    UNUSED(destructor);
    UNUSED(printer);

    struct binary_search_tree *bst =  (struct binary_search_tree*)malloc(sizeof(struct binary_search_tree));
    if(!bst){
        free(bst);
        return NULL;
    }
    bst->root = NULL;
    bst->comparator = comparator;
    bst->destructor = destructor;
    bst->printer = printer;
    bst->num_nodes = 0;
    return bst;
}

/**
 * Allocates and initializes a new Node with the passed in data, and return a pointer to it.
 *
 * Make sure to set the left and right pointers of the Node to NULL.
 *
 * @param data the data to be inserted in the node
 * @return a pointer to the newly constructed Node struct or NULL if data is NULL/malloc fails
 */
Node *create_node(void *data) {
    //TODO
    UNUSED(data);
    if(data == NULL){
        return ERROR;
    }
    struct Node* node = (struct Node*)malloc(sizeof(struct Node));
    if(!node){
        return NULL;
    }
    (*node).data = data;
    (*node).left = NULL;
    (*node).right = NULL;
    return node;
}

/**
 * Creates a new node given the passed in data and correctly inserts it into the passed in BST
 *
 * Refer to the Binary Search Tree Implementation in the PDF for the correct way to insert nodes into BSTs.
 *
 * The create_node function should be called in this function.
 *
 * @param tree the BST that the new Node should be inserted into
 * @param data the data to be inserted in a new Node
 * @return SUCCESS if the node is successfully added to the tree, otherwise ERROR if
 * the parameters are NULL, malloc fails, or the data is already in the BST
 */
int insert_node(binary_search_tree *tree, void *data) {
    //TODO
    UNUSED(tree);
    UNUSED(data);

    if(tree == NULL){
        return ERROR;
    }
    if(data == NULL){
        return ERROR;
    }
    

    struct Node *node = create_node(data);
    if (!node){
        return ERROR;
    }
    if(tree->root == NULL){
        tree->root = node;
        tree->num_nodes += 1;
        return SUCCESS;
    }
    else{
        struct Node *currentNode = tree->root;
        struct Node *parentNode = currentNode;

        while(currentNode){
            parentNode = currentNode;
            int compare = tree->comparator(data,currentNode->data);
        
            if(compare < 0){
                currentNode =  currentNode -> left;
            } else if(compare > 0){
                currentNode =  currentNode ->right;
            } else {
                free(node);
                return ERROR;
            }
        }
        int compari = tree->comparator(data, parentNode->data);
        if(compari < 0){
            parentNode->left =  node;
        } else{
            parentNode->right = node;
        }

        tree->num_nodes += 1;
        return SUCCESS;
    }
    
}


/**
 * Checks to see if a Node with the given data is in the BST.
 *
 * @param tree the BST that should be searched
 * @param data the data that is being looked for
 * @return SUCCESS if the data is found, ERROR if
 * the parameters are NULL or the data is not found
 */
int contains(binary_search_tree *tree, void *data) {
    //TODO
    UNUSED(tree);
    UNUSED(data);
    if(tree == NULL){
        return ERROR;
    }
    if(data == NULL){
        return ERROR;
    }

    struct Node *currentNode = tree->root;
    while(currentNode){
        int compare = tree->comparator(data,currentNode->data);
        if(compare < 0){
            currentNode =  currentNode ->left;
        } else if(compare > 0){
            currentNode =  currentNode ->right;
        } else {
            return SUCCESS;
        }
    }
    return ERROR;
}



/**
 * Recursive helper method for preorder_traversal().
 *
 * Note: This method is not directly tested. You will only be tested on your implementation of preorder_traversal().
 * However, you may find it helpful to use this function in your implementation of preorder_traversal().
 *
 * @param root the root node of the current subtree being traversed
 * @param arr the array of data that has been traversed
 * @param index the index at which to add the next data
 */
void preorder_helper(Node* root, void** arr, int* index) {
    //TODO
    UNUSED(root);
    UNUSED(arr);
    UNUSED(index);

    
    if(root == NULL){
        return;
    }
    if(arr == NULL){
        return;
    }
    if(index == NULL){
        return;
    }
    arr[*index] = root->data;
    *(index)+=1;

    preorder_helper(root->left,arr,index);
    preorder_helper(root->right,arr,index);

}

/**
 * Allocate and initialize an array of pointers that point to the data from the given tree in preorder traversal order.
 *
 * Refer to the Introduction in the PDF for a discussion on preorder tree traversal.
 *
 * @param tree the BST to be traversed
 * @return a newly created array of pointers that point to the data in preorder traversal order,
 * NULL if the tree is NULL or malloc fails
 */
void** preorder_traversal(binary_search_tree *tree) {
    //TODO
    UNUSED(tree);

    if(tree == NULL){
        return ERROR;
    }
    int num_nodes = tree->num_nodes;
    void** arr = (void**)malloc(num_nodes * sizeof(void*));
    if (arr == NULL) {
        return NULL;  
    }

    int index = 0;
    preorder_helper(tree->root, arr, &index);

    return arr; 
   
    


}

/**
 * Create a new tree that is a duplicate of the passed in tree excluding the node that has data that matches the data passed in.
 *
 * Make sure to completely free the previous tree using the destroy_tree function and data that matches data_removed.
 * Note: You should free the original tree (but not its data!). If you need to return NULL, ensure that the original tree is unchanged.
 *
 * @param tree the BST to duplicate without the data_removed
 * @param data_removed the data that should not be included in the duplicated tree
 * @return a pointer to the newly constructed binary_search_tree struct without the data_removed,
 * NULL if the inputs are NULL or malloc fails
 */
binary_search_tree *duplicate_without(binary_search_tree *tree, void *data_removed) {
    //TODO
    UNUSED(tree);
    UNUSED(data_removed);
    
    if(tree==NULL){
        return NULL;
    }
    if(data_removed==NULL){
        return NULL;
    }
    
   
    struct binary_search_tree *newTree = init_tree(tree->comparator, tree->destructor, tree->printer);
    if (!newTree) {
        return NULL;
    }

    int foundDataRemoved = -1;
    void** dataArray =  preorder_traversal(tree);

    for (size_t i = 0; i < tree->num_nodes; i++)
    {
        void* value = dataArray[i];
        int compar = tree->comparator(value,data_removed);
        if  (compar == 0){
            foundDataRemoved = i;
        } else {
            if(insert_node(newTree,value)==ERROR){
                return NULL;
            };
        }
        
    }
    
    if(foundDataRemoved >= 0){
        newTree->destructor(data_removed);
    } else {
        return NULL;
    }
    
    destroy_tree(tree,foundDataRemoved);
    return newTree;
}

/**
 * Free the passed in node and free all nodes that are direct and indirect descendants of the node.
 *
 * Only free the data associated with each node if destroy_data is 1. Otherwise, do NOT free the data of the freed nodes.
 * 
 * Note: This method is not directly tested. You will only be tested on your implementation of destroy_tree().
 * However, you may find it helpful to use this function in your implementation of destroy_tree().
 *
 * @param destructor the destructor to free the data
 * @param node the node that should be freed along with all the nodes below it
 * @param destroy_data if 1, free the data with the destructor for every node you free, otherwise do not free the data
 */
void destroy_node(void (*destructor)(void *), Node *node, int destroy_data) {
    //TODO
    UNUSED(destructor);
    UNUSED(node);
    UNUSED(destroy_data);
    if (node == NULL) {
        return;
    }
    destroy_node(destructor,node->left,destroy_data);
    destroy_node(destructor,node->right,destroy_data);

    if (destroy_data == 1){
       destructor(node->data);
    }
    free(node);


}

/**
 * Free the entire tree including all of the nodes.
 *
 * Only free the data if destroy_data is 1. Otherwise, do NOT free the data.
 *
 * The destroy_node function should be called in this function.
 *
 * @param destructor the tree to be destroyed
 * @param destroy_data if 1, free all the data, otherwise do not free the data
 */
void destroy_tree(binary_search_tree *tree, int destroy_data) {
    //TODO
    UNUSED(tree);
    UNUSED(destroy_data);
    destroy_node(tree->destructor,tree->root,destroy_data);
    free(tree);

}


/**
 * DO NOT EDIT - Already implemented for students
 *
 * Recursive helper for print_tree() function
 */
void print_helper(FILE *f, binary_search_tree *tree, Node *node, int level) {
    if (node->left) {
        for (int i = 0; i < level; i++) {
            fprintf(f, "    ");
        }
        fprintf(f, "L: ");
        tree->printer(f, node->left->data);
        fprintf(f, "\n");
        print_helper(f, tree, node->left, level+1);
    }

    if(node->right) {
        for (int i = 0; i < level; i++) {
            fprintf(f, "    ");
        }
        fprintf(f, "R: ");
        tree->printer(f, node->right->data);
        fprintf(f, "\n");
        print_helper(f, tree, node->right, level+1);
    }

}

/**
 * DO NOT EDIT - Already implemented for students
 *
 * Prints the BST.
 */
void print_tree(FILE *f, binary_search_tree *tree) {
    Node *root = tree->root;
    if (!root) {
        return;
    }
    fprintf(f, "Root: ");
    tree->printer(f, root->data);
    fprintf(f, "\n");
    print_helper(f, tree, root, 1);
}
