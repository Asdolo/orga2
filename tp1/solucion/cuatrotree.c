#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cuatrotree.h"

ctNode* search(ctNode** currNode, ctNode* fatherNode, uint32_t newVal){

  ctNode* res;

  if ((*currNode) == NULL){
    res = malloc(sizeof(ctNode));
    (res)->father = fatherNode;
    (*res).len = 0;
    (*res).child[0] = NULL;
    (*res).child[1] = NULL;
    (*res).child[2] = NULL;
    (*res).child[3] = NULL;

    (*currNode) = res;
  }else
  {

    if ((**currNode).len < 3){
      res = *currNode;
    }else{

      if (newVal < (**currNode).value[0])
      {
        res = search(&(**currNode).child[0], *currNode, newVal);
      }
      else if (newVal > (**currNode).value[0] && newVal < (**currNode).value[1])
      {
        res = search(&(**currNode).child[1], *currNode, newVal);
      }
      else if (newVal > (**currNode).value[1] && newVal < (**currNode).value[2])
      {
        res = search(&(**currNode).child[2], *currNode, newVal);
      }
      else if (newVal > (**currNode).value[2])
      {
        res = search(&(**currNode).child[3], *currNode, newVal);
      }else{
        res = NULL;
      }

    }


  }


  return res;
}

uint32_t fill(ctNode* currNode, uint32_t newVal) {

  uint32_t res = 1;

  if ((*currNode).len == 0)
  {
    //Recién creado
    (*currNode).value[0] = newVal;
  }
  else if ((*currNode).len == 1)
  {

    if (newVal < (*currNode).value[0])
    {
        (*currNode).value[1] = (*currNode).value[0];
        (*currNode).value[0] = newVal;
    }
    else if (newVal > (*currNode).value[0])
    {
      (*currNode).value[1] = newVal;
    }
    else
    {
      res = 0;
    }
  }
  else if ((*currNode).len == 2)
  {
    if (newVal < (*currNode).value[0])
    {
        (*currNode).value[2] = (*currNode).value[1];
        (*currNode).value[1] = (*currNode).value[0];
        (*currNode).value[0] = newVal;
    }
    else if (newVal > (*currNode).value[0] && newVal < (*currNode).value[1])
    {
        (*currNode).value[2] = (*currNode).value[1];
        (*currNode).value[1] = newVal;
    }
    else if (newVal > (*currNode).value[1])
    {
      (*currNode).value[2] = newVal;

    }
    else
    {
      res = 0;
    }
  }

  if (res == 1)
    (*currNode).len += 1;

  return res;

}

void ct_add(ctTree* ct, uint32_t newVal) {

  if (ct != NULL){

      ctNode** node = search(&(*ct).root, NULL, newVal);
      if(node != NULL){
        if (fill(node, newVal) == 1){
          (*ct).size += 1;
        }
      }

  }

}
